extends Node2D

## Reparte ingredientes en posiciones libres del mapa al entrar a la escena.

@export var escena_ingrediente: PackedScene
@export var mapa: TileMapLayer
@export var cantidad: int = 5
@export var intentos_por_punto: int = 80

func _ready() -> void:
	if escena_ingrediente == null or mapa == null:
		push_warning("SpawnerIngredientes: falta escena_ingrediente o mapa en el Inspector")
		return

	# Esperamos un frame de fisica para que el TileMap ya tenga sus colisiones activas
	await get_tree().physics_frame

	for i in cantidad:
		var pos := _buscar_posicion_libre()
		if pos == Vector2.INF:
			continue
		_crear_ingrediente(pos)

func _crear_ingrediente(pos: Vector2) -> void:
	var datos := CatalogoIngredientes.elegir_aleatorio()
	var ing: Ingrediente = escena_ingrediente.instantiate()
	ing.nombre_ingrediente = datos["nombre"]
	ing.textura = datos["textura"]
	add_child(ing)
	ing.global_position = pos

## Busca un punto al azar que no caiga dentro de una pared.
func _buscar_posicion_libre() -> Vector2:
	var rect := mapa.get_used_rect()
	var celda := Vector2(mapa.tile_set.tile_size)
	var desde := mapa.to_global(Vector2(rect.position) * celda)
	var hasta := mapa.to_global(Vector2(rect.end) * celda)

	for i in intentos_por_punto:
		var punto := Vector2(
			randf_range(desde.x + 16.0, hasta.x - 16.0),
			randf_range(desde.y + 16.0, hasta.y - 16.0)
		)
		if _esta_libre(punto):
			return punto

	return Vector2.INF

func _esta_libre(punto: Vector2) -> bool:
	var consulta := PhysicsPointQueryParameters2D.new()
	consulta.position = punto
	consulta.collision_mask = 1          # capa del TileMap
	consulta.collide_with_areas = false
	consulta.collide_with_bodies = true
	return get_world_2d().direct_space_state.intersect_point(consulta).is_empty()
