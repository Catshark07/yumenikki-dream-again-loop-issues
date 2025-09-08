@tool

class_name CamDeadzone
extends AreaRegion

# --- clamps the camera to the deadzone rect.
var in_deadzone: bool = false
@export var area: Area2D

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
