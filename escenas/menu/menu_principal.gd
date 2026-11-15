
extends Control
func _on_jugar_pressed():
	Musicamenu.stop_menusound()
	await Transicion.cambiar_escena(
		"res://escenas/mundo/taberna.tscn"
	)
func _on_opciones_pressed():
	Musicamenu.play_click()
	await Transicion.cambiar_escena(
		"res://escenas/menu/botones/opciones.tscn"
	)
func _on_salir_pressed():
	Musicamenu.stop_menusound()
	get_tree().quit()
func _on_creditos_pressed():
	Musicamenu.play_click()
	await Transicion.cambiar_escena(
		"res://escenas/menu/botones/creditos.tscn"
	)
