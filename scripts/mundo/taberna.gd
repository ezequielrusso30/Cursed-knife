extends Node2D

func _ready() -> void:
	
	var e: String = GameManager.entrada_pendiente
	
	
	var spawn := get_node_or_null("Spawn_" + e)
	
	
	if spawn and has_node("Player"):
		$Player.global_position = spawn.global_position
	else:
		push_warning("No se pudo posicionar al jugador: falta el Spawn o el nodo Player en la escena.")
