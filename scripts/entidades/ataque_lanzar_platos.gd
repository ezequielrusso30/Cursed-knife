class_name AtaqueLanzarPlatos
extends PatronAtaque

var _cantidad_proyectiles: int = 3

func _init() -> void:
	_tiempo_duracion = 0.5
	_cooldown = 4.0


func ejecutar(jefe: CharacterBody2D, _objetivo: Node2D) -> void:
	_en_ejecucion = true
	jefe.velocity = Vector2.ZERO
	print("El Jefe Cocinero arroja", _cantidad_proyectiles," platos hacia nosotros")


func detener(jefe: CharacterBody2D) -> void:
	super.detener(jefe)
