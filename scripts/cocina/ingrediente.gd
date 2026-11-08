class_name Ingrediente
extends Area2D

## Ingrediente que se puede recoger del suelo.
## El spawneador le asigna nombre y textura antes de agregarlo al arbol.

@export var nombre_ingrediente: String = "carne"
@export var textura: Texture2D

@onready var _sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if textura:
		_sprite.texture = textura
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	EventBus.item_recolectado.emit({"nombre": nombre_ingrediente})
	print("Recogiste: ", nombre_ingrediente)
	queue_free()
