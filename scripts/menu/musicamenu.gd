
extends Node
var music_player: AudioStreamPlayer
var ui_player: AudioStreamPlayer
var transition_player: AudioStreamPlayer
func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = preload("res://assets/sonidos/menu_sound.mp3")
	music_player.finished.connect(_on_music_finished)
	music_player.play()
	ui_player = AudioStreamPlayer.new()
	add_child(ui_player)
	transition_player = AudioStreamPlayer.new()
	add_child(transition_player)
func _on_music_finished():
	music_player.play()
func stop_menusound():
	if music_player.playing:
		music_player.stop()
func play_hover():
	ui_player.stream = preload("res://assets/sonidos/01_hover_bell.wav")
	ui_player.play()
func play_click():
	ui_player.stream = preload("res://assets/sonidos/02_button_click.wav")
	ui_player.play()
func play_transition():
	transition_player.stream = preload("res://assets/sonidos/03_scene_transition.wav")
	transition_player.play()
