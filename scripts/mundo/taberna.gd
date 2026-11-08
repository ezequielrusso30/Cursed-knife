## Taberna - Hub del juego entre expediciones.
## Ubica al jugador en el spawn segun la entrada usada.
extends Node2D

func _ready() -> void:
	var e := GameManager.entrada_pendiente
	var spawn := get_node_or_null("Spawn_" + e)
	if spawn:
		$Player.global_position = spawn.global_position
