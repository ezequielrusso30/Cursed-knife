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

# --- ESTRATEGIAS DE ATAQUE ( PATRON ESTRATEGIA) ---
var _patron_actual: PatronAtaque = null
var _patron_embestida: AtaqueEmbestida
var _patron_platos: AtaqueLanzarPlatos
var _timer_duracion_ataque: float = 0.0


func _ready() -> void:
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

# --- POLIMORFISMO: Persecucion del Jefe ---
func perseguir_objetivo(delta: float) -> void:
	# 1. Actualizar recargas de ataques
	_patron_embestida.actualizar_cooldown(delta)
	_patron_platos.actualizar_cooldown(delta)

	# 2. Si esta en medio de un ataque (embistiendo)
	if _esta_atacando:
		_timer_duracion_ataque -= delta
		if _timer_duracion_ataque <= 0.0:
			_finalizar_ataque()
		move_and_slide()
		return

# 3. Si el ataque esta listo, ataca
	if _puede_atacar():
		atacar()
		move_and_slide()
		return

# 4. Si no esta atacando, camina hacia el jugador
	var direccion = global_position.direction_to(_objetivo.global_position)
	velocity = direccion * _velocidad
	move_and_slide()

# --- POLIMORFISMO: Ejecucion de Ataques con Estrategia ---
func atacar() -> void:
	_esta_atacando = true
	_seleccionar_siguiente_patron()

	# Al embestir se abre una ventana donde el jugador le puede hacer parry
	if _patron_actual is AtaqueEmbestida:
		_es_vulnerable_parry = true

	_timer_duracion_ataque = _patron_actual._tiempo_duracion
	_patron_actual.ejecutar(self, _objetivo)

func _finalizar_ataque() -> void:
	_esta_atacando = false
	_es_vulnerable_parry = false
	if _patron_actual:
		_patron_actual.detener(self)

func _puede_atacar() -> bool:
	if _fase_actual == 1:
		return _patron_embestida.esta_listo()
	else:
		return _patron_actual.esta_listo() or _patron_platos.esta_listo()

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

	# Evaluar cambio a Fase 2 (Enfurecido) al bajar del 50% de vida
	if _fase_actual == 1 and _salud <= (_salud_max * _vida_fase_2_porcentaje):
		cambiar_fase(2)


func cambiar_fase(nueva_fase: int) -> void:
	_fase_actual = nueva_fase
	_velocidad *= 1.3
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
	print("JEFE COCINERO DERROTADO")

	# Desbloqueo seguro de la progresion(si el Autoload ya existe en el proyecto)
	if has_node("/root/Progresion"):
		get_node("/root/Progresion").call("romper_sello")

	# Notificacion global atraves del EventBus si existe
	if has_node("/root/EventBus"):
		get_node("/root/EventBus").emit_signal("jefe_derrotado", self)

	super.morir()
