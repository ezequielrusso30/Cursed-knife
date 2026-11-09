extends StaticBody2D

## Olla de la arena: mientras el jugador esta cerca, cocina un ingrediente
## del inventario y le aplica su efecto.

const ANCHO_BARRA := 100.0

@export var tiempo_coccion: float = 1.2

@onready var _zona: Area2D = $ZonaCoccion
@onready var _barra: ColorRect = $BarraCoccion

var _jugador: Node = null
var _progreso: float = 0.0
var _cocido_en_esta_visita: bool = false

func _ready() -> void:
	$AnimatedSprite2D.play("burbujeo")
	_barra.size.x = 0.0
	_zona.body_entered.connect(_on_entrada)
	_zona.body_exited.connect(_on_salida)

func _on_entrada(body: Node2D) -> void:
	if body.is_in_group("jugador"):
		_jugador = body

func _on_salida(body: Node2D) -> void:
	if body != _jugador:
		return
	_jugador = null
	_progreso = 0.0
	_barra.size.x = 0.0
	_cocido_en_esta_visita = false

func _process(delta: float) -> void:
	if _jugador == null:
		return

	if _cocido_en_esta_visita:
		return

	if Inventario.get_total() <= 0:
		_progreso = 0.0
		_barra.size.x = 0.0
		return

	_progreso += delta
	_barra.size.x = ANCHO_BARRA * clampf(_progreso / tiempo_coccion, 0.0, 1.0)

	if _progreso >= tiempo_coccion:
		_progreso = 0.0
		_barra.size.x = 0.0
		_cocinar()

func _cocinar() -> void:
	var nombre := Inventario.get_primero()
	if nombre == "":
		return
	Inventario.quitar(nombre)
	_jugador.aplicar_efecto(CatalogoIngredientes.get_efecto(nombre))
	_cocido_en_esta_visita = true
	print("Cocinaste: ", nombre)
