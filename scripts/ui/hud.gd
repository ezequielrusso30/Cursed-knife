extends CanvasLayer

## Muestra ingredientes, vida del jugador, vida del jefe,
## el objetivo de la fase actual y mensajes cortos.
## Vive en cada escena de mundo.

@onready var _label: Label = $Label
@onready var _barra: ColorRect = $BarraVida
@onready var _barra_jefe: Control = $BarraJefe
@onready var _vida_jefe: ColorRect = $BarraJefe/Vida
@onready var _objetivo: Label = $Objetivo
@onready var _mensaje: Label = $Mensaje

const ANCHO_BARRA := 100.0
const ANCHO_BARRA_JEFE := 200.0
const DURACION_MENSAJE := 2.5

func _ready() -> void:
	Inventario.cambio_inventario.connect(_actualizar)
	EventBus.ui_actualizar_vida.connect(_actualizar_vida)
	EventBus.ui_actualizar_vida_jefe.connect(_actualizar_vida_jefe)
	EventBus.ui_mostrar_mensaje.connect(_mostrar_mensaje)
	FaseManager.fase_cambiada.connect(_actualizar_objetivo)

	_actualizar()
	_actualizar_vida(EstadoJugador.vida_actual, EstadoJugador.vida_max)
	_actualizar_objetivo(FaseManager.get_fase_actual(), -1)

	_mensaje.text = ""
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

## Cambia el cartel de objetivo cuando FaseManager avisa.
func _actualizar_objetivo(nueva_fase: int, _fase_anterior: int) -> void:
	_objetivo.text = _texto_objetivo(nueva_fase)

## Muestra un mensaje corto en pantalla y lo borra solo.
func _mostrar_mensaje(texto: String) -> void:
	_mensaje.text = texto
	await get_tree().create_timer(DURACION_MENSAJE).timeout

	# Solo se limpia si nadie mostro otro mensaje mientras esperabamos
	if _mensaje.text == texto:
		_mensaje.text = ""

func _texto_objetivo(fase: int) -> String:
	match fase:
		FaseManager.Fase.TUTORIAL:
			return "Hablá con el cuchillo"
		FaseManager.Fase.BOSQUE:
			return "Juntá 3 ingredientes"
		FaseManager.Fase.PELEA_JEFE:
			return "Cociná y vencé al jefe"
		FaseManager.Fase.VICTORIA:
			return "Volvé a la taberna con la receta"
		_:
			return ""
