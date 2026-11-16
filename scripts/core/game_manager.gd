
extends Node

signal juego_iniciado
signal juego_pausado
signal juego_reanudado
signal juego_terminado(victoria: bool)
var jefe_derrotado: bool = false
var _terminado: bool = false
var entrada_pendiente: String = "Sur"
const ESCENA_GAME_OVER = "res://escenas/ui/game_over.tscn"
const ESCENA_VICTORIA = "res://escenas/ui/victoria.tscn"
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	EventBus.jugador_murio.connect(_on_jugador_murio)
	EventBus.jefe_murio.connect(_on_jefe_murio)
func iniciar_juego() -> void:
	_terminado = false
	jefe_derrotado = false
	get_tree().paused = false
	juego_iniciado.emit()
func pausar_juego() -> void:
	if get_tree().paused or _terminado:
		return
	get_tree().paused = true
	juego_pausado.emit()
func reanudar_juego() -> void:
	if not get_tree().paused:
		return
	get_tree().paused = false
	juego_reanudado.emit()
func esta_pausado() -> bool:
	return get_tree().paused
func esta_terminado() -> bool:
	return _terminado
func _on_jugador_murio() -> void:
	terminar_juego(false)
func _on_jefe_murio(jefe: Node) -> void:
	jefe_derrotado = true
func ganar_por_cuchillo() -> void:
	if _terminado:
		return
	if not jefe_derrotado:
		return
	terminar_juego(true)
func terminar_juego(victoria: bool) -> void:
	if _terminado:
		return
	_terminado = true
	get_tree().paused = false
	Musicamenu.stop_game_music()

	juego_terminado.emit(victoria)

	var ruta = ESCENA_VICTORIA if victoria else ESCENA_GAME_OVER
	call_deferred("_cambiar_escena_final", ruta)
func _cambiar_escena_final(ruta: String) -> void:
	if not ResourceLoader.exists(ruta):
		push_error("No existe la escena: " + ruta)
		return
	await Transicion.cambiar_escena(ruta)
func cambiar_escena(ruta: String, entrada: String) -> void:
	entrada_pendiente = entrada
	get_tree().call_deferred("change_scene_to_file", ruta)
