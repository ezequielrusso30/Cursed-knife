## Puerta - Area de transicion entre escenas.
## Al entrar el jugador, cambia de escena usando GameManager.
extends Area2D

@export var escena_destino: String
@export var entrada: String = "Sur"

func _ready() -> void:
	body_entered.connect(_al_entrar)

func _al_entrar(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		GameManager.cambiar_escena(escena_destino, entrada)
