## EventBus - Autoload 
## Hub centralizado de señales. Cualqueir nodo puede emitir o escuchar señales
## a traves de este bus en lugar de acoplarse directamente entre si.
## Agregar este script en ajustes de proyecto Autoload como "EventBus".

extends Node

# Señales del jugador
signal  jugador_spawneado(jugador: Node)
signal jugador_danio_recibido(cantidad: int, vida_actual: int)
signal jugador_curado(cantidad: int, vida_actual: int)
signal jugador_murio

# Señales de enemigos
signal enemigo_spawneado(enemigo: Node)
signal enemigo_danio_recibido(enemigo: Node, cantidad: int)
signal enemigo_murio(enemigo: Node)

# Señales del jefe
signal jefe_spawneado(jefe: Node)
signal jefe_fase_cambio(jefe: Node, nueva_fase: int)
signal jefe_murio(jefe: Node)

# Señales de items/inventario
signal item_dropeado(item: Node, posicion: Vector2)
signal item_recolectado(datos_item: Dictionary)
signal receta_obtenida

# Señales de UI
signal ui_actualizar_vida(vida_actual: int, vida_max: int)
signal ui_actualizar_vida_jefe(vida_actual: int, vida_max: int)
signal ui_mostrar_mensaje(texto: String)

# Señales de flujo de juego
signal juego_pausado
signal juego_reanudado
signal nivel_completado
signal juego_terminado(victoria: bool)
