@tool
class_name PanoramaPreviewer
extends EditorPlugin

static var panorama_viewport: 	SubViewport = null:
	set = preview

static var panorama_texture: Texture2D = null

func _forward_canvas_draw_over_viewport(viewport_control: Control) -> void:
	viewport_control.draw_circle(viewport_control.get_local_mouse_position(), 90, Color.RED)
	
func _forward_canvas_gui_input(event: InputEvent) -> bool:
	update_overlays()
	return true
	
static func preview(_viewport: SubViewport) -> void:
	if _viewport == null: return
	
	panorama_viewport = _viewport
	panorama_texture = _viewport.get_texture()
	
	Utils.connect_to_signal(
		func(): panorama_viewport = null, 
		panorama_viewport.tree_exiting, 
		Object.CONNECT_ONE_SHOT)
	
func _exit_tree() -> void:
	panorama_texture 	= null
	panorama_viewport 	= null
