extends Personaje_base
class_name Jugador # Clase jugador
@onready var attack_sound = preload("res://assets/sonidos/574821__wenpire__slash1.ogg")

func _ready() -> void:
	add_to_group("jugador")
	_vida = EstadoJugador.vida_actual
	vida_max = EstadoJugador.vida_max
	EventBus.ui_actualizar_vida.emit(int(_vida), int(vida_max))

func _physics_process(delta: float) -> void:
	if  Input.is_action_just_pressed("ui_accept") : # esto era para testear las animaciones de recibir daño, 
													   # lo pueden borrar si quieren chicos
		recibir_danio(30)
	if estado == "Muerto" or estado == "Golpeado":
		return
	movimiento()
	move_and_slide()
	ataque() 



func movimiento():
	var direccion = Input.get_vector("mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo")
	if direccion != Vector2.ZERO and !atacar: # Si el personaje no esta quieto y no esta atacando
		estado = "Moviendose"
		if abs(direccion.x) > abs(direccion.y):
			if direccion.x > 0: 
				ultima_direccion = "Right"; animacion(ultima_direccion,estado)
			else : ultima_direccion = "Left"; animacion(ultima_direccion,estado)
		else : 
			if direccion.y > 0: ultima_direccion = "Down"; animacion(ultima_direccion,estado)
			else: ultima_direccion = "Up"; animacion(ultima_direccion,estado)
	elif direccion == Vector2.ZERO and !atacar: # Si no se mueve y atacar no es verdadero
		estado = "Idle" 
		animacion(ultima_direccion,estado) # Esto antes de la func era un choclo con un monton de if y elif 😭
		
	velocity = direccion * speed
	velocity.normalized()
	return estado

func ataque() :
	if Input.is_action_just_pressed("atacar") :
		attack_sound
		estado = "Atacando"
		atacar = true
		animacion(ultima_direccion,estado)
		await $AnimatedSprite2D.animation_finished
		estado = movimiento() # Para ver si se esta moviendo o no, la funcion movimiento va a retornar el estado del personaje
		atacar = false
	
	
## Aplica el efecto de un ingrediente coci	nado.
func aplicar_efecto(efecto: Dictionary) -> void:
	match efecto.get("tipo", ""):
		"danio":
			_dmg += efecto.get("valor", 0)
		"velocidad":
			speed += efecto.get("valor", 0)
		"curacion":
			_vida = min(vida_max, _vida + efecto.get("valor", 0))
			EventBus.ui_actualizar_vida.emit(int(_vida), int(vida_max))
