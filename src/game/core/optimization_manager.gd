class_name Optimization
extends Game.GameSubClass

static func _setup() -> void: 
	setup_overridden_project_settings()

static var override_godot_default_settings: bool = true
static var footstep_instances: int = 0

const FOOTSTEP_MAX_INSTANCES: int = 16
const PARTICLES_MAX_INSTANCES: int = 128

static func setup_overridden_project_settings() -> void:
	if override_godot_default_settings:
		RenderingServer.viewport_set_default_canvas_item_texture_repeat(
			Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_MIRROR)
		RenderingServer.viewport_set_default_canvas_item_texture_filter(
			Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
		
		Application.main_window.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
		Application.main_window.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
		Application.main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
static func set_max_fps(_max_fps: int) -> void:
	Engine.max_fps = _max_fps
