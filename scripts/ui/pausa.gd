
extends CanvasLayer
const menu_principal = "res://escenas/menu/menu_principal.tscn"
@onready var panel_pausa = $Control
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	panel_pausa.hide()
func actualizar_elementos_ui(visible_ui: bool) -> void:
	var elementos = get_tree().get_nodes_in_group("ocultar_en_pausa")
	for elemento in elementos:
		elemento.visible = visible_ui
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if get_tree().paused:
			return
		panel_pausa.show()
		actualizar_elementos_ui(false)
		get_tree().paused = true
		get_viewport().set_input_as_handled()
func _on_reanudar_pressed() -> void:
	get_tree().paused = false
	panel_pausa.hide()
	actualizar_elementos_ui(true)
func _on_salir_pressed() -> void:
	get_tree().paused = false
	actualizar_elementos_ui(true)
	Musicamenu.play_menusound()
	get_tree().change_scene_to_file(menu_principal)
