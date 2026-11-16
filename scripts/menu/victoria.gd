
extends Control
func _on_salir_pressed() -> void:
	Musicamenu.play_menusound()
	get_tree().change_scene_to_file("res://escenas/menu/menu_principal.tscn")
