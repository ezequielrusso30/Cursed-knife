extends Node2D

func _ready() -> void:
	var e := GameManager.entrada_pendiente
	var spawn := get_node_or_null("Spawn_" + e)
	if spawn:
		$Player.global_position = spawn.global_position
