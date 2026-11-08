class_name AtaqueEmbestida
extends PatronAtaque

## Estrategia concreta de ataque: el jefe carga en linea recta hacia el jugador
## durante un segundo. Es parryable, asi que abre una ventana de contraataque.

var _velocidad_embestida: float = 300.0
var _direccion_carga: Vector2 = Vector2.ZERO

func _init() -> void:
	_tiempo_duracion = 1.0
	_cooldown = 2.5

## Calcula la direccion hacia el objetivo y aplica la velocidad de carga.
func ejecutar(jefe: CharacterBody2D, objetivo: Node2D) -> void:
	_en_ejecucion = true
	_direccion_carga = jefe.global_position.direction_to(objetivo.global_position)
	jefe.velocity = _direccion_carga * _velocidad_embestida

## Frena al jefe y delega el cooldown a la clase base.
func detener(jefe: CharacterBody2D) -> void:
	jefe.velocity = Vector2.ZERO
	super.detener(jefe)

func get_animacion() -> String:
	return "attack_alt"

func es_parryable() -> bool:
	return true
