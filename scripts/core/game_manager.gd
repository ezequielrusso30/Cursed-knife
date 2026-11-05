## GameManager - Autoload
## Maneja el flujo general del juego: inicio, pausa/reanudar y fin de partida.
## Agregar este script en ajustes de proyecto: Autoload como "GameManager".

extends Node


# Señales que otros sistemas pueden ver.
signal juego_iniciado
signal juego_pausado
signal juego_reanudado
signal juego_terminado(victoria: bool)

var _terminado: bool = false


func _ready() -> void: #Para que manager siga funcionando pausado
	process_mode = Node.PROCESS_MODE_ALWAYS

func esta_pausado() -> bool:
	return get_tree().paused

func esta_terminado() -> bool:
	return _terminado

func iniciar_juego() -> void:
	##Se llama para iniciar o reiniciar el juego desde el comienzo del nivel actual.
	_terminado = false
	get_tree().paused = false
	juego_iniciado.emit()
	# Reiniciar datos del nivel aca si es necesario 

func pausar_juego() -> void:
	if esta_pausado() or _terminado:
		return
	get_tree().paused = true
	juego_pausado.emit()


func reanudar_juego() -> void:
	if not esta_pausado():
		return
	get_tree().paused = false
	juego_reanudado.emit()

func terminar_juego(victoria: bool) -> void:
	if _terminado:
		return
	_terminado = true
	get_tree().paused = false
	juego_terminado.emit(victoria)
	#Cambiar escena, mostrar UI.

var entrada_pendiente: String = "Sur"

func cambiar_escena(ruta: String, entrada: String) -> void:
	entrada_pendiente = entrada
	get_tree().call_deferred("change_scene_to_file", ruta)
