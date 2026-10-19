class_name PatronAtaque
extends RefCounted

## Clase abstracta (Patron Estrategia) para los ataques del jefe
## Desacopla la logica de ataque del cuerpo fisico del JefeCocinero

var _tiempo_duracion: float = 2.0
var _cooldown: float = 3.0
var _timer_cooldown: float = 0.0
var _en_ejecucion: bool = false


func esta_listo() -> bool:
	return _timer_cooldown <= 0.0 and not _en_ejecucion


func actualizar_cooldown(delta: float) -> void:
	if _timer_cooldown > 0.0:
		_timer_cooldown -= delta


## Metodo abstracto
func ejecutar(_jefe: CharacterBody2D, _objetivo: Node2D) -> void:
	push_error("El metodo ejecutar() deber ser implementado por la estrategia concreta")

## Metodo abstracto
func detener(_jefe: CharacterBody2D) -> void:
	_en_ejecucion = false
	_timer_cooldown = _cooldown

func get_duracion() -> float:
	return _tiempo_duracion
