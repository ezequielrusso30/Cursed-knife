## Bosque - Escena de recoleccion de ingredientes.
## Fija la fase BOSQUE y ubica al jugador en el spawn segun la entrada usada.
extends Node2D

func _ready() -> void:
	FaseManager.ir_a_fase(FaseManager.Fase.BOSQUE)

	var e := GameManager.entrada_pendiente
	var spawn := get_node_or_null("Spawn_" + e)
	if spawn:
		$Player.global_position = spawn.global_position
