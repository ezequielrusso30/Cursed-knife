extends Area2D

## Plato que lanza el Jefe Cocinero en fase 2.
## Vuela en linea recta, gira y hace dano al tocar al jugador.

@export var velocidad: float = 220.0
@export var danio: float = 15.0
@export var duracion: float = 3.0
@export var giro: float = 8.0

var _direccion: Vector2 = Vector2.RIGHT
var _tiempo_vida: float = 0.0

func _ready() -> void:
	z_index = 2
	_tiempo_vida = duracion
	body_entered.connect(_on_body_entered)

## Se llama antes de agregarlo al arbol.
func configurar(direccion: Vector2) -> void:
	_direccion = direccion.normalized()

func _physics_process(delta: float) -> void:
	position += _direccion * velocidad * delta
	rotation += giro * delta

	_tiempo_vida -= delta
	if _tiempo_vida <= 0.0:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("jugador"):
		return
	if body.has_method("recibir_danio"):
		body.recibir_danio(danio)
	queue_free()
