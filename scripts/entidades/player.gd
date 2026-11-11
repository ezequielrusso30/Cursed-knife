@abstract class_name  Personaje_base
extends CharacterBody2D
@export var speed = 400
@export var _dmg = 20
var _vida = 100
@export var vida_max = 100
var ultima_direccion = "Down" # Se almacena la ultima direccion
var estado = "Idle" # estado actual del personaje
var atacar = false # si esta atacando

func recibir_danio(cantidad) -> void:
	if estado == "Muerto" or estado == "Golpeado": return # si esta muerto o golpeado el personaje no recibe daño
	if cantidad <= 0: return
	_vida = _vida - cantidad
	EstadoJugador.guardar(_vida, vida_max)
	EventBus.ui_actualizar_vida.emit(int(_vida), int(vida_max))
	if _vida <= 0:
		_vida = 0
		estado = "Muerto"
		speed = 0
		animacion(ultima_direccion, estado)
		await $AnimatedSprite2D.animation_finished 
		queue_free()
	else :
		estado = "Golpeado"
		animacion(ultima_direccion, estado)
		speed = 0
		await $AnimatedSprite2D.animation_finished
	estado = "Idle"
	speed = 400 # se restablece la velocidad del jugador

func animacion(direccion , estadoPJ): # toma la ultima direccion del jugador y su estado, asi en base a eso hace la animacion
	if estadoPJ == "Idle":
		$AnimatedSprite2D.play("Idle" + direccion)
	elif estadoPJ == "Moviendose":
		$AnimatedSprite2D.play("Walk" + direccion)
	elif estadoPJ == "Atacando":
		$AnimatedSprite2D.play("WalkAttack" + direccion)
	elif estadoPJ == "Golpeado":
		$AnimatedSprite2D.play("Hurt" + direccion)
	else :
		$AnimatedSprite2D.play("Death" + direccion)

@abstract
func ataque() -> void
	
