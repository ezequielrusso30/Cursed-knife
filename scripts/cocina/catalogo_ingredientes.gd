class_name CatalogoIngredientes
extends RefCounted

## Unica fuente de verdad: que ingredientes existen y con que sprite.
## Lo usan tanto el spawneador del bosque como los enemigos que sueltan drops.

const TEXTURAS := {
	"carne": preload("res://assets/sprites/items/carne.png"),
	"cebolla": preload("res://assets/sprites/items/cebolla.png"),
	"leche": preload("res://assets/sprites/items/frasco de leche.png"),
	"miel": preload("res://assets/sprites/items/miel.png"),
	"pescado": preload("res://assets/sprites/items/pescado.png"),
}

static func elegir_aleatorio() -> Dictionary:
	var nombre: String = TEXTURAS.keys().pick_random()
	return {"nombre": nombre, "textura": TEXTURAS[nombre]}

const EFECTOS := {
	"carne": {"tipo": "danio", "valor": 5.0},
	"pescado": {"tipo": "danio", "valor": 3.0},
	"cebolla": {"tipo": "velocidad", "valor": 60.0},
	"leche": {"tipo": "curacion", "valor": 25.0},
	"miel": {"tipo": "curacion", "valor": 15.0},
}

static func get_efecto(nombre: String) -> Dictionary:
	return EFECTOS.get(nombre, {})
