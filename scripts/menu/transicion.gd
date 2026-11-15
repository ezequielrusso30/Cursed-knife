
extends CanvasLayer
var cambiando := false
var pantalla: ColorRect
func _ready():
	layer = 100
	pantalla = ColorRect.new()
	pantalla.color = Color(0, 0, 0, 0)
	pantalla.mouse_filter = Control.MOUSE_FILTER_IGNORE
	pantalla.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(pantalla)
func cambiar_escena(ruta: String):
	if cambiando:
		return
	cambiando = true
	# Oscurecer la pantalla
	var tween = create_tween()
	tween.tween_property(pantalla, "color:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(ruta)
	await get_tree().process_frame
	var tween2 = create_tween()
	tween2.tween_property(pantalla, "color:a", 0.0, 0.5)
	await tween2.finished
	cambiando = false
