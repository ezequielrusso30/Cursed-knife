## Menu principal - Pantalla de inicio del juego.
## Botones para jugar, ver opciones y salir.
extends Control

func _ready() -> void:
	$Centrar/Botones/JUGAR.pressed.connect(_on_jugar)
	$Centrar/Botones/OPCIONES.pressed.connect(_on_opciones)
	$Centrar/Botones/SALIR.pressed.connect(_on_salir)
	$Centrar/Botones/JUGAR.grab_focus()

func _on_jugar() -> void:
	GameManager.iniciar_juego()
	GameManager.entrada_pendiente = "Sur"
	get_tree().change_scene_to_file("res://escenas/mundo/taberna.tscn")

func _on_opciones() -> void:
	pass # después: panel de opciones

func _on_salir() -> void:
	get_tree().quit()
