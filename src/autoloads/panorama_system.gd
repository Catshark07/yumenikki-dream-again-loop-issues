class_name PanoramaSystem
extends Component

@export var panorama_rect: TextureRect
@export var default_panorama_texture: Texture

const MINIMUM_SIZE := Vector2(480, 270)

var initial: bool = false
var initial_screen_centre := Vector2()
var screen_centre 	:= Vector2()

var viewport_size 	:= Vector2()
var eqn 			:= Vector2()
var total_uv_offset := Vector2()

var warp_check: bool = false
var panorama_update: EventListener

static var instance: PanoramaSystem

func _setup() -> void:
	instance = self
	panorama_rect.global_position = Vector2.ZERO
	
	panorama_update = EventListener.new(["WORLD_LOOP"], false, self)
	panorama_update.do_on_notify(["WORLD_LOOP"], func(): warp_check = true)
	
	initial_screen_centre = (
		Application.main_viewport.get_camera_2d().get_screen_center_position()
			if Application.main_viewport.get_camera_2d()
			else Vector2.ZERO)
			
	viewport_size = Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	)
	
func _physics_update(_delta: float) -> void:
	screen_centre = (
		Application.main_viewport.get_camera_2d().get_screen_center_position()
		if Application.main_viewport.get_camera_2d()
		else Vector2.ZERO) - initial_screen_centre

	if !warp_check and CameraHolder.instance != null:
		eqn = screen_centre / Application.get_viewport_dimens()
	elif warp_check: warp_check = false
	
	RenderingServer.global_shader_parameter_set("uv_offset",  eqn)

func apply_panorama(_panorama: Node) -> void:
	if _panorama == null: return # - not needed.
	
	eqn = Vector2.ZERO
	panorama_rect.visible = true
	RenderingServer.global_shader_parameter_set("uv_offset",  Vector2.ZERO)
	
	if _panorama is Control:
		_panorama.visible = false
		panorama_rect.texture 				= default_panorama_texture
		panorama_rect.material				= _panorama.material
		
		if _panorama is TextureRect:
			panorama_rect.texture 				= _panorama.texture
			panorama_rect.expand_mode			= _panorama.expand_mode
			panorama_rect.stretch_mode			= _panorama.stretch_mode
		
	elif _panorama is SubViewport:
		panorama_rect.texture 				= _panorama.get_texture()
		panorama_rect.material				= null
		
	panorama_rect.custom_minimum_size = MINIMUM_SIZE
	panorama_rect.size = Vector2(480, 270)
func remove_panorama() -> void:
	panorama_rect.visible = false
