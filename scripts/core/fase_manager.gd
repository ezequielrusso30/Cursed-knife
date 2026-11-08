## FaseManager - Autoload
## Maneja las fases del juego (ej: tutorial, bosque, pelea de jefe).
## Rastrea la fase actual y notifica cuando cambia.
## FaseManager - Autoload
## Maneja las fases del juego (tutorial, bosque, pelea de jefe, victoria).
## Rastrea la fase actual y notifica cuando cambia.
## Se carga ultimo porque depende de EventBus y GameManager.

extends Node

# --- SEÑALES ---
signal fase_cambiada(nueva_fase: int, fase_anterior: int)

## Constantes de fase (agregar mas segun se necesite)
enum Fase {
	TUTORIAL,
	BOSQUE,
	PELEA_JEFE,
	VICTORIA,
	DERROTA,
}

const ULTIMA_FASE := Fase.DERROTA

var _fase_actual: int = Fase.TUTORIAL

func _ready() -> void:
	# El manager escucha al bus en lugar de que cada escena lo llame a mano.
	EventBus.jugador_murio.connect(_on_jugador_murio)
	EventBus.receta_obtenida.connect(_on_receta_obtenida)
	GameManager.juego_iniciado.connect(_on_juego_iniciado)


# --- API PUBLICA ---
func get_fase_actual() -> int:
	return _fase_actual

func es_terminal() -> bool:
	return _fase_actual == Fase.VICTORIA or _fase_actual == Fase.DERROTA

func siguiente_fase() -> void:
	if es_terminal():
		return
	ir_a_fase(mini(_fase_actual + 1, ULTIMA_FASE))

func fase_anterior() -> void:
	ir_a_fase(maxi(_fase_actual - 1, Fase.TUTORIAL))

## Unico punto por el que se cambia de fase: valida, guarda y emite la señal.
func ir_a_fase(indice_fase: int) -> void:
	if not _es_fase_valida(indice_fase):
		push_warning("Fase invalida ignorada: " + str(indice_fase))
		return
	if indice_fase == _fase_actual:
		return

	var anterior := _fase_actual
	_fase_actual = indice_fase
	fase_cambiada.emit(indice_fase, anterior)
	print("Fase: ", anterior, " -> ", indice_fase)

func _es_fase_valida(valor: int) -> bool:
	return valor >= 0 and valor < Fase.size()


# --- REACCIONES AL BUS DE EVENTOS ---
## Una partida nueva vuelve al inicio.
func _on_juego_iniciado() -> void:
	ir_a_fase(Fase.TUTORIAL)

## Si el jugador muere, la partida queda en derrota.
func _on_jugador_murio() -> void:
	ir_a_fase(Fase.DERROTA)

## Conseguir la receta cierra el tramo de combate del MVP.
func _on_receta_obtenida() -> void:
	ir_a_fase(Fase.VICTORIA)
