## FaseManager - Autoload
## Maneja las fases del juego (ej: tutorial, bosque, pelea de jefe).
## Rastrea la fase actual y notifica cuando cambia.
## Agregar este script en ajustes de proyecto como Autoload , "FaseManager".

extends Node

# Señales
signal fase_cambiada(nueva_fase: int, fase_anterior: int)

## Constantes de fase (agregar mas segun se necesite)
enum Fase{
	TUTORIAL,
	BOSQUE,
	PELEA_JEFE,
	VICTORIA,
	DERROTA,
}

const ULTIMA_FASE := Fase.DERROTA

var _fase_actual: int = Fase.TUTORIAL:
	set(valor):
		if not _es_fase_valida(valor):
			push_warning("Fase invalida ignorada: " + str(valor))
		if valor == _fase_actual:
			return
		var anterior := _fase_actual
		_fase_actual = valor
		fase_cambiada.emit(valor, anterior)

func _ready() -> void:
	pass


# API publica
func get_fase_actual() -> int:
	return _fase_actual

func es_terminal() -> bool:
	return _fase_actual == Fase.VICTORIA or _fase_actual == Fase.DERROTA

func siguiente_fase() -> void:
	if es_terminal():
		return
	_fase_actual = mini(_fase_actual + 1, ULTIMA_FASE)

func fase_anterior() -> void:
	_fase_actual = maxi(_fase_actual - 1, Fase.TUTORIAL)

func ir_a_fase(indice_fase: int) -> void:
	_fase_actual = indice_fase

func _es_fase_valida(valor: int) -> bool:
	return valor >= 0 and valor < Fase.size()
