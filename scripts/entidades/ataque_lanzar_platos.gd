class_name AtaqueLanzarPlatos
extends PatronAtaque

## Lanza una tanda de platos en abanico hacia el jugador.
## Solo se usa en la fase 2 del jefe.

const ESCENA_PLATO := preload("res://escenas/enemigos/plato.tscn")

var _cantidad_proyectiles: int = 3
var _dispersion_grados: float = 12.0

func _init() -> void:
	_tiempo_duracion = 0.5
	_cooldown = 4.0

func ejecutar(jefe: CharacterBody2D, objetivo: Node2D) -> void:
	_en_ejecucion = true
	jefe.velocity = Vector2.ZERO

	if objetivo == null:
		return

	var origen := jefe.global_position
	var base := origen.direction_to(objetivo.global_position)

	for i in _cantidad_proyectiles:
		var desvio := (i - (_cantidad_proyectiles - 1) / 2.0) * _dispersion_grados
		_lanzar_plato(jefe, origen, base.rotated(deg_to_rad(desvio)))

func _lanzar_plato(jefe: CharacterBody2D, origen: Vector2, direccion: Vector2) -> void:
	var padre := jefe.get_parent()
	var plato = ESCENA_PLATO.instantiate()
	plato.configurar(direccion)
	plato.position = padre.to_local(origen)
	# Se agrega al final del frame para no tocar el arbol en plena fisica
	padre.call_deferred("add_child", plato)

func detener(jefe: CharacterBody2D) -> void:
	super.detener(jefe)
