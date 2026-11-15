
extends Node
var music_player: AudioStreamPlayer
func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = preload("res://escenas/menu/assets/menu_sound.mp3")
	music_player.finished.connect(_on_music_finished)
	music_player.play()
func _on_music_finished():
	music_player.play()
func stop_menusound():
	if music_player.playing:
		music_player.stop()
