extends Area2D
class_name Ataque


func _physics_process(delta: float) -> void:
	calcular_posicion()



func calcular_posicion() :
	if $"..".atacar:
		if $"..".ultima_direccion == "Up":
			$ColisionAtaque.position = Vector2(0,-16)
			$ColisionAtaque.rotation_degrees = 90
			$"../AnimatedSprite2D/AnimationPlayer".play("WalkAttack" + $"..".ultima_direccion)
		elif $"..".ultima_direccion == "Down":
			$ColisionAtaque.rotation_degrees = 90
			$ColisionAtaque.position = Vector2(0,16)
			$"../AnimatedSprite2D/AnimationPlayer".play("WalkAttack" + $"..".ultima_direccion)
		elif $"..".ultima_direccion == "Left":
			$ColisionAtaque.position = Vector2(-16,0)
			$ColisionAtaque.rotation_degrees = 180
			$"../AnimatedSprite2D/AnimationPlayer".play("WalkAttack" + $"..".ultima_direccion)
		elif $"..".ultima_direccion == "Right":
			$ColisionAtaque.position = Vector2(16,0)
			$ColisionAtaque.rotation_degrees = 180
			$"../AnimatedSprite2D/AnimationPlayer".play("WalkAttack" + $"..".ultima_direccion)


func _on_area_entered(area: Area2D) -> void:
	if area.has_method("recibir_danio"):
		area.recibir_danio($".."._dmg)
	pass # Replace with function body.


func _on_body_entered(body: Node2D) -> void:
	if  body.has_method("recibir_danio"):
		body.recibir_danio($".."._dmg)
	pass # Replace with function body.
