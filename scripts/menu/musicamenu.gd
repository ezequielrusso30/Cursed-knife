
extends Node
var music_player: AudioStreamPlayer
var ui_player: AudioStreamPlayer
var transition_player: AudioStreamPlayer
var game_player: AudioStreamPlayer
const AMBIENT = preload("res://assets/sonidos/ambient.mp3")
const BOSS_FIGHT = preload("res://assets/sonidos/bossfight.mp3")
const MENU_MUSIC = preload("res://assets/sonidos/menu_sound.mp3")

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	music_player.stream = MENU_MUSIC
	music_player.finished.connect(_on_music_finished)
	ui_player = AudioStreamPlayer.new()
	add_child(ui_player)
	transition_player = AudioStreamPlayer.new()
	add_child(transition_player)
	game_player = AudioStreamPlayer.new()
	add_child(game_player)
	game_player.volume_db = -18.0
	play_menusound()

func _on_music_finished():
	if music_player:
		music_player.play()
func play_menusound():
	if game_player:
		game_player.stop()
	if music_player:
		music_player.stop()
		music_player.play()
func stop_menusound():
	if music_player:
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
func play_ambient():
	stop_menusound()
	if game_player.stream == AMBIENT and game_player.playing:
		return
	game_player.stream = AMBIENT
	game_player.play()
func play_boss_fight():
	stop_menusound()
	if game_player.stream == BOSS_FIGHT and game_player.playing:
		return
	game_player.stream = BOSS_FIGHT
	game_player.play()
func stop_game_music():
	if game_player:
		game_player.stop()
