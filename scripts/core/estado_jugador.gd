extends Node

## Vida del jugador que sobrevive a los cambios de escena.
## El jugador la lee al aparecer y la guarda cada vez que recibe dano.

var vida_max: int = 100
var vida_actual: int = 100
var receta_obtenida: bool = false

func _ready() -> void:
	GameManager.juego_iniciado.connect(reiniciar)

## Guarda la vida actual para el proximo cambio de escena.
func guardar(actual: float, maxima: float) -> void:
	vida_max = int(maxima)
	vida_actual = clampi(int(actual), 0, vida_max)

func reiniciar() -> void:
	vida_max = 100
	vida_actual = vida_max
	receta_obtenida = false
