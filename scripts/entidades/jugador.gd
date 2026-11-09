extends Personaje_base
class_name jugador # Clase jugador
var estado = "Idle" # estado actual del personaje
var ultima_direccion = "Down" # Se almacena la ultima direccion
var atacar = false # si esta atacando

func _ready() -> void:
	add_to_group("jugador")
	_vida = EstadoJugador.vida_actual
	vidaMax = EstadoJugador.vida_max
	EventBus.ui_actualizar_vida.emit(int(_vida), int(vidaMax))

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
		estado = "Atacando"
		atacar = true
		animacion(ultima_direccion,estado)
		await $AnimatedSprite2D.animation_finished
		estado = movimiento() # Para ver si se esta moviendo o no, la funcion movimiento va a retornar el estado del personaje
		atacar = false

func recibir_danio(cantidad):
	if estado == "Muerto" or estado == "Golpeado": return # si esta muerto o golpeado el personaje no recibe daño
	if cantidad <= 0: return
	_vida = _vida - cantidad
	EstadoJugador.guardar(_vida, vidaMax)
	EventBus.ui_actualizar_vida.emit(int(_vida), int(vidaMax))
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
	estado = movimiento()
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
	
## Aplica el efecto de un ingrediente cocinado.
func aplicar_efecto(efecto: Dictionary) -> void:
	match efecto.get("tipo", ""):
		"danio":
			dmg += efecto.get("valor", 0)
		"velocidad":
			speed += efecto.get("valor", 0)
		"curacion":
			_vida = min(vidaMax, _vida + efecto.get("valor", 0))
			EventBus.ui_actualizar_vida.emit(int(_vida), int(vidaMax))
