class_name EnemigoSlime
extends Enemigo

##Enemigo basico de mazmorra
##Se desplaza hacia el jugador mediante saltos con impulsos y friccion
##Al morir, suelta ingredientes de cocina para el loop del juego

# --- ATRIBUTOS PROPIOS DEL SLIME ---
@export_group("Comportamiento Slime")
@export var _fuerza_salto: float = 140.0
@export var _tiempo_entre_saltos: float =1.2
@export var _friccion: float = 400.0
@export var _probabilidad_drop: float = 0.7

#Referencias visuales  (nodos hijos en la escena
@onready var _anim: AnimatedSprite2D = $AnimatedSprite2D
var _timer_salto: float = 0.0
@warning_ignore("unused_private_class_variable")
var _en_el_aire: bool = false


func _ready() -> void:
	super._ready() # Inicia la salud de la clase base
	_nombre = "Slime de Mazmorra"
	_timer_salto = _tiempo_entre_saltos
	_objetivo = get_tree().get_first_node_in_group("jugador")
	_anim.play("idle")
	$Hitbox.body_entered.connect(_on_hitbox_body_entered)

# --- POLIMORFISMO: Sobreescribimos perseguir_objetivo ---
## El slime acumula tiempo y se impulsa hacia el jugador
func perseguir_objetivo(delta: float) -> void:
	if _timer_salto <= 0.0:
		var direccion = global_position.direction_to(_objetivo.global_position)
		velocity = direccion * _fuerza_salto
		_timer_salto = _tiempo_entre_saltos
		if _anim and direccion.x != 0:
			_anim.flip_h = direccion.x < 0
		_anim.play("walk")
	else:
		velocity = velocity.move_toward(Vector2.ZERO, _friccion * delta)
		if velocity.length() < 10:
			_anim.play("idle")
		move_and_slide()

	_timer_salto -= delta
	if _timer_salto <= 0.0:
		# Salto hacia el jugador
		var direccion = global_position.direction_to(_objetivo.global_position)
		velocity = direccion * _fuerza_salto
		_timer_salto = _tiempo_entre_saltos

		#Orientar el sprite segun hacia donde salta
		if _anim and  direccion.x != 0:
			_anim.flip_h = direccion.x < 0
	else:
		#Aplicamos friccion mientras aterriza o espera el proximo salto
		velocity = velocity.move_toward(Vector2.ZERO, _friccion * delta)
		move_and_slide()


# --- POLIMORFISMO: Sobreescribimos atacar ---
func atacar() -> void:
	#El slime daña por contacto fisico al tocar al jugador
	pass

func recibir_danio(cantidad: float) -> void:
	super.recibir_danio(cantidad)
	if esta_vivo():
		_anim.play("hurt")


# --- POLIMORFISMO: Sobreescribimos _soltar_drop ---
## Al morir, evalua si suelta un ingrediente para la taberna
func _soltar_drop() -> void:
	if randf() > _probabilidad_drop:
		return

	var padre := get_parent()
	var escena: PackedScene = preload("res://escenas/cocina/ingredientes.tscn")
	var datos := CatalogoIngredientes.elegir_aleatorio()
	var ing: Ingrediente = escena.instantiate()
	ing.nombre_ingrediente = datos["nombre"]
	ing.textura = datos["textura"]
	ing.position = padre.to_local(global_position)

	# No se puede agregar un Area2D mientras el motor resuelve colisiones
	# (justo cuando el slime muere por el golpe). Lo dejamos para el final del frame.
	padre.call_deferred("add_child", ing)

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("jugador") and body.has_method("recibir_danio"):
		body.recibir_danio(_danio_contacto)
