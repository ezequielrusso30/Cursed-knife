class_name CuchilloMaldito
extends StaticBody2D

# Variables privadas de control (Encapsulamiento)
var _ingredientes_recolectados: Array = []
const CANTIDAD_REQUERIDA: int = 3
var _hablo_en_taberna: bool = false
var _clics_actuales: int = 0
var _mensaje_activo: bool = false

# Nodos del cartel flotante creados por código puro
var _capa_flotante: CanvasLayer = null
var _cuadro_dialogo: Panel = null
var _texto_letras: Label = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	# reconocer item
	EventBus.item_recolectado.connect(_on_item_recolectado)

# guardar solo con nombres diferentes
func _on_item_recolectado(datos_item: Dictionary) -> void:
	if datos_item.has("tipo") and datos_item["tipo"] == "ingrediente" and datos_item.has("nombre"):
		var nombre_ingrediente = datos_item["nombre"]
		if not nombre_ingrediente in _ingredientes_recolectados:
			_ingredientes_recolectados.append(nombre_ingrediente)
			print("¡Ingrediente único recolectado!: ", nombre_ingrediente)

func _on_zona_interacion_body_entered(body: Node2D) -> void:
	if body.name == "Player" or body.is_in_group("jugador"):
		if not _mensaje_activo:
			_procesar_mision_por_choque()

func _input(event: InputEvent) -> void:
	if _mensaje_activo and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_clics_actuales += 1
		if _clics_actuales >= 2:
			_borrar_cartel_de_pantalla()

# control de carteles
func _procesar_mision_por_choque() -> void:
	var fase_actual = FaseManager.get_fase_actual()
	
	if fase_actual == FaseManager.Fase.TUTORIAL and not _hablo_en_taberna:
		_hablo_en_taberna = true
		_mostrar_cartel_pantalla("Cuchillo Maldito: ¡Elfa! Quieres libertad?? vence al cocinero con la receta ancestral...\nBusca los 3 ingredientes sagrados en el bosque para poder pelear.\n[Da 2 clics para continuar]")
		FaseManager.siguiente_fase() 
		
	else:
		if _ingredientes_recolectados.size() >= CANTIDAD_REQUERIDA:
			_mostrar_cartel_pantalla("Cuchillo Maldito: ¡Excelente! Los ingredientes están completos.\nJefe Cocinero: ¡¿Cómo?! ¡Esto es una batalla de cocina definitiva y vamos a pelear!\n[¡Combate Habilitado! Da 2 clics para iniciar la pelea]")
		else:
			var lista_actual = ", ".join(_ingredientes_recolectados) if _ingredientes_recolectados.size() > 0 else "Ninguno"
			_mostrar_cartel_pantalla("Cuchillo Maldito: Te faltan ingredientes.\nLlevas: " + str(_ingredientes_recolectados.size()) + "/3 (" + lista_actual + ").\n[Da 2 clics para continuar]")

func _mostrar_cartel_pantalla(texto_dialogo: String) -> void:
	_clics_actuales = 0
	_mensaje_activo = true
	get_tree().paused = true 
	
	_capa_flotante = CanvasLayer.new()
	_capa_flotante.layer = 10 
	
	_cuadro_dialogo = Panel.new()
	_cuadro_dialogo.custom_minimum_size = Vector2(700, 120)
	_cuadro_dialogo.size = Vector2(700, 120)
	_cuadro_dialogo.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	_cuadro_dialogo.position.y = -150
	
	_texto_letras = Label.new()
	_texto_letras.text = texto_dialogo
	_texto_letras.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_texto_letras.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_texto_letras.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	_texto_letras.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_texto_letras.add_theme_color_override("font_color", Color.WHITE)
	
	_cuadro_dialogo.add_child(_texto_letras)
	_capa_flotante.add_child(_cuadro_dialogo)
	get_tree().current_scene.add_child(_capa_flotante)
	
	var pantalla_ancho = get_viewport_rect().size.x
	_cuadro_dialogo.position.x = (pantalla_ancho / 2) - (_cuadro_dialogo.size.x / 2)

func _borrar_cartel_de_pantalla() -> void:
	_mensaje_activo = false
	get_tree().paused = false 
	
	if _capa_flotante:
		_capa_flotante.queue_free() 
		_capa_flotante = null
		
	if _ingredientes_recolectados.size() >= CANTIDAD_REQUERIDA:
		FaseManager.ir_a_fase(FaseManager.Fase.PELEA_JEFE)
