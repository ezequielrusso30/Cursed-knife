extends Area2D

## Receta especial que suelta el jefe. Se recoge con la tecla de interactuar.

@onready var _etiqueta: Label = $Etiqueta

var _jugador_cerca: bool = false

func _ready() -> void:
	body_entered.connect(_on_entrada)
	body_exited.connect(_on_salida)
	_etiqueta.visible = false

func _on_entrada(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		_jugador_cerca = true
		_etiqueta.visible = true

func _on_salida(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		_jugador_cerca = false
		_etiqueta.visible = false

func _process(_delta: float) -> void:
	if _jugador_cerca and Input.is_action_just_pressed("interactuar"):
		_recoger()

func _recoger() -> void:
	EstadoJugador.receta_obtenida = true
	EventBus.receta_obtenida.emit()
	print("Conseguiste la receta especial")
	queue_free()
