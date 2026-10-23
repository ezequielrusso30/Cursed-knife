extends CharacterBody2D

@export var speed = 400


func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	


func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed
	velocity.normalized()
	if Input.is_action_just_pressed("golpear") :
		$Ataque/CollisionShape2D.set("disabled", false) 
		pass
