## Pausa - Menu de pausa del juego.
## Se abre con la tecla de pausa y permite reanudar o volver al menu.
extends CanvasLayer

func _ready() -> void:
	visible = false
	$Control/Centrar/Botones/Reanudar.pressed.connect(_on_reanudar)
	$Control/Centrar/Botones/SalirMenu.pressed.connect(_on_salir_menu)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		if get_tree().paused:
			_on_reanudar()
		else:
			_on_pausar()

func _on_pausar() -> void:
	get_tree().paused = true
	visible = true
	$Control/Centrar/Botones/Reanudar.grab_focus()

func _on_reanudar() -> void:
	get_tree().paused = false
	visible = false

func _on_salir_menu() -> void:
	get_tree().paused = false
	GameManager.entrada_pendiente = "Sur"
	get_tree().change_scene_to_file("res://escenas/menú inicio/menu_principal.tscn")
