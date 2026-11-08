class_name JefeCocinero
extends Enemigo

## Jefe final del MVP
## Coordina dos fases de combate, patrones de ataque intercambiables y mecanicas de parry

signal fase_cambiada(nueva_fase: int)
signal quedo_aturdido()

# --- ATRIBUTOS PROPIOS DEL JEFE ---
@export_group("Fases y Salud")
@export var _vida_fase_2_porcentaje: float = 0.5 # Se enfurece al 50% de vida

var _fase_actual: int = 1
var _es_vulnerable_parry: bool = false
var _tiempo_aturdido: float = 0.0
var _tiempo_hurt: float = 0.0
var _tiempo_furia: float = 0.0

# --- ESTRATEGIAS DE ATAQUE ( PATRON ESTRATEGIA) ---
var _patron_actual: PatronAtaque = null
var _patron_embestida: AtaqueEmbestida
var _patron_platos: AtaqueLanzarPlatos
var _timer_duracion_ataque: float = 0.0

@onready var _anim: AnimatedSprite2D = $AnimatedSprite2D
func _ready() -> void:
	FaseManager.ir_a_fase(FaseManager.Fase.PELEA_JEFE)

	_nombre = "Jefe Cocinero"
	_salud_max = 120.0
	_velocidad = 100.0
	_danio_contacto = 20.0
	_rango_deteccion = 350.0
	super._ready()


#Instanciamos los patrones de ataque 
	_patron_embestida = AtaqueEmbestida.new()
	_patron_platos = AtaqueLanzarPlatos.new()
	_patron_actual = _patron_embestida
	_objetivo = get_tree().get_first_node_in_group("jugador")
	_anim.play("idle_down")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)
	# Se difiere porque el HUD todavia no existe cuando corre este _ready
	EventBus.ui_actualizar_vida_jefe.emit.call_deferred(int(_salud), int(_salud_max))


# --- POLIMORFISMO: Persecucion del Jefe ---
func perseguir_objetivo(delta: float) -> void:
	# Aturdido por parry
	if _tiempo_aturdido > 0.0:
		_tiempo_aturdido -= delta
		velocity = Vector2.ZERO
		_anim.play("stunned")
		return

	# Momento de furia al entrar a fase 2
	if _tiempo_furia > 0.0:
		_tiempo_furia -= delta
		velocity = Vector2.ZERO
		return

# Golpe recibido: se queda quieto mostrando "hurt"
	if _tiempo_hurt > 0.0:
		_tiempo_hurt -= delta
		velocity = Vector2.ZERO
		return

	_patron_embestida.actualizar_cooldown(delta)
	_patron_platos.actualizar_cooldown(delta)

	# Durante un ataque
	if _esta_atacando:
		_timer_duracion_ataque -= delta
		if _timer_duracion_ataque <= 0.0:
			_finalizar_ataque()
		else:
			_anim.play(_patron_actual.get_animacion())
		return

	if _objetivo == null:
		velocity = Vector2.ZERO
		_anim.play("idle_down" if _fase_actual == 1 else "idle_fase2")
		return

	# Ataca si esta en rango y el patron esta listo
	var distancia = global_position.distance_to(_objetivo.global_position)
	if distancia <= _rango_deteccion and _puede_atacar():
		velocity = Vector2.ZERO
		atacar()
		return

	# Persigue
	var direccion = global_position.direction_to(_objetivo.global_position)
	velocity = direccion * _velocidad
	_animar_movimiento(direccion)

# --- POLIMORFISMO: Ejecucion de Ataques con Estrategia ---
func atacar() -> void:
	_esta_atacando = true
	_seleccionar_siguiente_patron()

	# La estrategia decide si abre ventana de parry
	_es_vulnerable_parry = _patron_actual.es_parryable()

	_timer_duracion_ataque = _patron_actual.get_duracion()
	_patron_actual.ejecutar(self, _objetivo)

func _finalizar_ataque() -> void:
	_esta_atacando = false
	_es_vulnerable_parry = false
	if _patron_actual:
		_patron_actual.detener(self)

func _puede_atacar() -> bool:
	if _fase_actual == 1:
		return _patron_embestida.esta_listo()
	return _patron_embestida.esta_listo() or _patron_platos.esta_listo()

func _seleccionar_siguiente_patron() -> void:
	if _fase_actual == 1:
		_patron_actual = _patron_embestida
	else:
		# En fase 2 alterna entre platos y embestida segun disponibilidad
		if _patron_platos.esta_listo():
			_patron_actual = _patron_platos
		else:
			_patron_actual = _patron_embestida

# --- GESTION DE FASES Y DAÑO ---
func recibir_danio(cantidad: float) -> void:
	super.recibir_danio(cantidad)
	EventBus.ui_actualizar_vida_jefe.emit(int(_salud), int(_salud_max))

	if not esta_vivo():
		return

	# Feedback de golpe, salvo que este a mitad de un ataque
	if not _esta_atacando:
		_tiempo_hurt = 0.5
		_anim.play("hurt")

	# Evaluar cambio a Fase 2 (Enfurecido) al bajar del 50% de vida
	if _fase_actual == 1 and _salud <= (_salud_max * _vida_fase_2_porcentaje):
		cambiar_fase(2)


func cambiar_fase(nueva_fase: int) -> void:
	_fase_actual = nueva_fase
	_velocidad *= 1.3
	_tiempo_hurt = 0.0
	_tiempo_furia = 1.2
	_anim.play("idle_fase2")
	fase_cambiada.emit(_fase_actual)
	print("EL JEFE COCINERO ENTRO EN FASE 2")

# --- MECANICA DE PARRY ---
## Llamado si el jugador logra bloquear/reflejar el ataque en la ventana justa
func al_recibir_parry() -> void:
	if not _es_vulnerable_parry:
		return

	_finalizar_ataque()
	_tiempo_aturdido = 2.0
	velocity = Vector2.ZERO
	quedo_aturdido.emit()
	print("¡Parry exitoso! El Jefe Cocinero quedo aturdido")

# --- POLIMORFISMO: Muerte y Recompensa del MVP ---
func morir() -> void:
	if _esta_muerto:
		return

	# Frenamos la IA y mostramos la animacion de muerte
	_esta_muerto = true
	_anim.play("death")
	$Hitbox/CollisionShape2D.set_deferred("disabled", true)

	print("JEFE COCINERO DERROTADO")

	# Desbloqueo seguro de la progresion (si el Autoload ya existe en el proyecto)
	if has_node("/root/Progresion"):
		get_node("/root/Progresion").call("romper_sello")

	# Senal que si existe en el EventBus
	EventBus.jefe_murio.emit(self)

	# Esperamos a que termine la animacion antes de liberar el nodo
	await _anim.animation_finished

	_soltar_receta()

	# La base hace el resto: emite murio, apaga colisiones y libera
	_esta_muerto = false
	super.morir()

func _animar_movimiento(direccion: Vector2) -> void:
	if abs(direccion.x) > abs(direccion.y):
		_anim.play("walk_right")
		_anim.flip_h = direccion.x < 0
	elif direccion.y < 0:
		_anim.play("walk_up")
	else:
		_anim.play("walk_down")

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") and body.has_method("recibir_danio"):
		body.recibir_danio(_danio_contacto)

## Suelta la receta especial donde murio el jefe.
func _soltar_receta() -> void:
	var padre := get_parent()
	var escena: PackedScene = preload("res://escenas/cocina/receta_especial.tscn")
	var receta: Node2D = escena.instantiate()
	receta.position = padre.to_local(global_position)
	# Diferido para no tocar el arbol en pleno frame de animacion
	padre.call_deferred("add_child", receta)
