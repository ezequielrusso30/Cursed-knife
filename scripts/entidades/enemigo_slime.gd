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
@onready var _sprite: Sprite2D = $Sprite2D

var _timer_salto: float = 0.0
@warning_ignore("unused_private_class_variable")
var _en_el_aire: bool = false


func _ready() -> void:
	super._ready() # Inicia la salud de la clase base
	_nombre = "Slime de Mazmorra"
	_timer_salto = _tiempo_entre_saltos

# --- POLIMORFISMO: Sobreescribimos perseguir_objetivo ---
## El slime acumula tiempo y se impulsa hacia el jugador
func perseguir_objetivo(delta: float) -> void:
	var distancia = global_position.distance_to(_objetivo.global_position)
	#Solo salta si el jugador esta dentro de su rango de deteccion
	if distancia > _rango_deteccion:
		velocity = velocity.move_toward(Vector2.ZERO, _friccion * delta)
		move_and_slide()
		return

	_timer_salto -= delta
	if _timer_salto <= 0.0:
		# Salto hacia el jugador
		var direccion = global_position.direction_to(_objetivo.global_position)
		velocity = direccion * _fuerza_salto
		_timer_salto = _tiempo_entre_saltos

		#Orientar el sprite segun hacia donde salta
		if _sprite and  direccion.x != 0:
			_sprite.flip_h = direccion.x < 0
	else:
		#Aplicamos friccion mientras aterriza o espera el proximo salto
		velocity = velocity.move_toward(Vector2.ZERO, _friccion * delta)
		
		move_and_slide()


# --- POLIMORFISMO: Sobreescribimos atacar ---
func atacar() -> void:
	#El slime daña por contacto fisico al tocar al jugador
	pass


# --- POLIMORFISMO: Sobreescribimos _soltar_drop ---
## Al morir, evalua si suelta un ingrediente para la taberna
func _soltar_drop() -> void:
	var azar = randf()
	if azar <= _probabilidad_drop:
		print("El slime solto un ingrediente de cocina")
	#Aca instanciamos el item en la posicion actual
