class_name AtaqueEmbestida
extends PatronAtaque

var _velocidad_embestida: float = 300.0
var _direccion_carga: Vector2 = Vector2.ZERO

func _init() -> void:
	_tiempo_duracion = 1.0
	_cooldown = 2.5


func ejecutar(jefe: CharacterBody2D, objetivo: Node2D) -> void:
	_en_ejecucion = true
	_direccion_carga = jefe.global_position.direction_to(objetivo.global_position)
	jefe.velocity = _direccion_carga * _velocidad_embestida

func detener(jefe: CharacterBody2D) -> void:
	jefe.velocity = Vector2.ZERO
	super.detener(jefe)
