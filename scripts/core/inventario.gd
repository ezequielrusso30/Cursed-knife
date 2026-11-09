extends Node

## Inventario global: sobrevive a los cambios de escena.
## Escucha el EventBus y acumula lo que el jugador va recogiendo.

signal cambio_inventario

var _ingredientes: Dictionary = {}

func _ready() -> void:
	EventBus.item_recolectado.connect(_on_item_recolectado)
	GameManager.juego_iniciado.connect(limpiar)

func _on_item_recolectado(datos: Dictionary) -> void:
	agregar(datos.get("nombre", "desconocido"))
	print("Inventario: ", get_todos())

func agregar(nombre: String, cantidad: int = 1) -> void:
	_ingredientes[nombre] = _ingredientes.get(nombre, 0) + cantidad
	cambio_inventario.emit()

func get_cantidad(nombre: String) -> int:
	return _ingredientes.get(nombre, 0)

## Devuelve el nombre de un ingrediente que tengas, o "" si no hay ninguno.
func get_primero() -> String:
	for nombre in _ingredientes:
		if _ingredientes[nombre] > 0:
			return nombre
	return ""

## Consume una unidad. Devuelve false si no la tenias.
func quitar(nombre: String, cantidad: int = 1) -> bool:
	if _ingredientes.get(nombre, 0) < cantidad:
		return false

	_ingredientes[nombre] -= cantidad
	if _ingredientes[nombre] <= 0:
		_ingredientes.erase(nombre)

	cambio_inventario.emit()
	return true

func get_total() -> int:
	var total := 0
	for n in _ingredientes:
		total += _ingredientes[n]
	return total

func get_todos() -> Dictionary:
	return _ingredientes.duplicate()

func limpiar() -> void:
	_ingredientes.clear()
	cambio_inventario.emit()
