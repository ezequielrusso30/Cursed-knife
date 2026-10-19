class_name Enemigo
extends CharacterBody2D

## Clase abstracta base para todos los enemigos del juego.
## Maneja salud, deteccion de objetivo, daño por contacto y ciclo de muerte

# --- SEÑALES ---
signal salud_cambiada(salud_actual: float, salud_maxima: float)
signal danio_recibido(cantida: float)
signal murio(enemigo: Enemigo)

# --- ATRIBUTOS PROTEGIDOS ---
@export_group("Estadisticas Base")
@export var _nombre: String = "Enemigo"
@export var _salud_max: float = 30.0
@export var _danio_contacto: float = 10.0
@export var _velocidad: float = 60.0
@export_group("Deteccion y Combate")
@export var _rango_deteccion: float = 100.0

var _salud: float = 30.0
var _esta_muerto: bool = false
var _esta_atacando: bool = false
var _objetivo: Node2D = null

func _ready() -> void:
	_salud = _salud_max


func _physics_process(delta: float) -> void:
	if _esta_muerto:
		return

#Si tenemos objetivo asignado y no estamos atacando, lo perseguimos
	if _objetivo:
		perseguir_objetivo(delta)
	else:
#Frenado natural si no hay objetivo
		velocity = velocity.move_toward(Vector2.ZERO, _velocidad * delta)
	move_and_slide()


# --- GETTERS Y SETTERS (Encapsulamiento) ---
func get_nombre() -> String:
	return _nombre

func get_rango_deteccion() -> float:
	return _rango_deteccion

func get_salud() -> float:
	return _salud

func get_salud_max() -> float:
	return _salud_max

func get_danio() -> float:
	return _danio_contacto

func get_objetivo() -> Node2D:
	return _objetivo

func set_objetivo(nuevo_objetivo: Node2D) -> void:
	_objetivo = nuevo_objetivo

func esta_vivo() -> bool:
	return not _esta_muerto

# --- METODOS VIRTUALES (Polimorfismo para que implementen los hijos) ---

## Metodo abstracto: cada subclase define como persigue (el slime salta, el jefe camina/carga)
func perseguir_objetivo(_delta: float) -> void:
	push_error("El metodo perseguir_objetivo() debe ser implementado por la subclase")

func atacar() -> void:
	push_error("El metodo atacar() debe ser implementado por la subclase")

## Metodo virtual: sobrescrito si el enemigo suelta ingredientes (Slime) o recetas/sellos (Jefe)
func _soltar_drop() -> void:
		pass

# --- LOGICA DE COMBATE GENERAL ---
## Aplica daño, emite señales y evaula si la entidad muere
func recibir_danio(cantidad: float) -> void:
	if _esta_muerto or cantidad <= 0.0:
		return

	_salud = max(0.0, _salud - cantidad)
	danio_recibido.emit(cantidad)
	salud_cambiada.emit(_salud, _salud_max)

	if _salud <= 0.0:
		morir()

func morir() -> void:
	if _esta_muerto:
		return
	_esta_muerto = true
	murio.emit(self)
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)
	_soltar_drop()
	queue_free()

func esta_atacando() -> bool:
	return _esta_atacando
