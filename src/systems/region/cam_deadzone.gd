@tool

class_name CamDeadzone
extends AreaRegion

# --- clamps the camera to the deadzone rect.
var in_deadzone: bool = false
@export var area: Area2D

func _ready() -> void:
	super()
	
	for i in range(32):
		set_collision_layer_value(i + 1, false)
		set_collision_mask_value(i + 1, false)
	
	set_collision_mask_value(31, true)

func _setup() -> void:	
	process_mode = Node.PROCESS_MODE_ALWAYS
	if rect.shape.size.x < 480: rect.shape.size.x = 480
	if rect.shape.size.y < 270: rect.shape.size.y = 270
	
	if Engine.is_editor_hint(): 
		set_physics_process(false)
		set_process(true)
	
	else: 
		set_physics_process(true)
		set_process(false)
			
func get_min_clamp_pos() -> Vector2:
	return (rect.global_position) - (rect.shape.size / 2) + Vector2(480, 270) * .5
func get_max_clamp_pos() -> Vector2:
	return (rect.global_position) + (rect.shape.size / 2) - Vector2(480, 270) * .5

func _handle_player_enter() -> void: 
	CameraHolder.instance.components.get_component_by_name("deadzone_manager").curr_deadzone = self
func _handle_player_exit() -> void: 
	CameraHolder.instance.components.get_component_by_name("deadzone_manager").curr_deadzone = null
