extends Control
# Cambios de escena
func _on_jugar_pressed():
	get_tree().change_scene_to_file("res://escenas/menu/botones/jugar.tscn") #Reemplazar luego con la escena ingame
func _on_opciones_pressed():
	get_tree().change_scene_to_file("res://escenas/menu/botones/opciones.tscn")
func _on_salir_pressed():
	get_tree().quit()
