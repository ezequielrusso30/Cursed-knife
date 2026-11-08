extends CanvasLayer

## Muestra ingredientes, vida del jugador y vida del jefe.
## Vive en cada escena de mundo.

@onready var _label: Label = $Label
@onready var _barra: ColorRect = $BarraVida
@onready var _barra_jefe: Control = $BarraJefe
@onready var _vida_jefe: ColorRect = $BarraJefe/Vida

const ANCHO_BARRA := 100.0
const ANCHO_BARRA_JEFE := 200.0

func _ready() -> void:
	Inventario.cambio_inventario.connect(_actualizar)
	EventBus.ui_actualizar_vida.connect(_actualizar_vida)
	EventBus.ui_actualizar_vida_jefe.connect(_actualizar_vida_jefe)
	_actualizar()
	_actualizar_vida(EstadoJugador.vida_actual, EstadoJugador.vida_max)
	_barra_jefe.visible = false

func _actualizar() -> void:
	_label.text = "Ingredientes: %d" % Inventario.get_total()

func _actualizar_vida(vida_actual: int, vida_max: int) -> void:
	var proporcion := float(vida_actual) / float(vida_max)
	_barra.size.x = ANCHO_BARRA * proporcion

func _actualizar_vida_jefe(vida_actual: int, vida_max: int) -> void:
	if vida_actual <= 0:
		_barra_jefe.visible = false
		return

	_barra_jefe.visible = true
	var proporcion := float(vida_actual) / float(vida_max)
	_vida_jefe.size.x = ANCHO_BARRA_JEFE * proporcion
