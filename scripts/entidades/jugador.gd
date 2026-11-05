extends CharacterBody2D

@export var speed = 400

func _ready() -> void:
	add_to_group("jugador")

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	


func get_input():
	var input_direction = Input.get_vector("mover_izquierda", "mover_derecha", "mover_arriba", "mover_abajo")
	velocity = input_direction * speed
	velocity.normalized()
	if Input.is_action_just_pressed("atacar") :
		$Ataque/CollisionShape2D.set("disabled", false) 
		pass
