@tool

class_name CamDeadzone
extends AreaRegion

# --- clamps the camera to the deadzone rect.
var in_deadzone: bool = false

func _ready() -> void:
	super()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	
	if Engine.is_editor_hint(): 
		set_physics_process(false)
		set_process(true)
	
	else: 
		set_physics_process(true)
		set_process(false)
		
func _physics_process(delta: float) -> void:
	if in_deadzone and CameraHolder.instance != null:
		CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
			(rect.global_position) - (rect.shape.size / 2) + Vector2(480, 270) * .5,
			(rect.global_position) + (rect.shape.size / 2) - Vector2(480, 270) * .5
			)
			
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(-rect.shape.size / 2 , 20, Color.RED)
		draw_circle(rect.shape.size / 2, 20, Color.RED)
	#(rect.global_position - rect.shape.size / 2) + Game.get_viewport_dimens() / 2,
	#(rect.global_position + rect.shape.size / 2) - Game.get_viewport_dimens() / 2
			#
		
func _handle_player_enter() -> void: in_deadzone = true
func _handle_player_exit() -> void: in_deadzone = false



#class square_deadzone:
	#extends Strategy
	#
	#func _update(_delta: float, _context: Variant = null) -> void: 
		#if _context.shape.size < Vector2(480, 270): _context.shape.size =  Vector2(480, 270)
		#
	#func _physics_update(_delta: float, _context: Variant = null) -> void: 
		#CameraHolder.instance.global_position = CameraHolder.instance.global_position.clamp(
			#_context.get_parent().global_position + (Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2),
			#_context.get_parent().global_position + (_context.shape.size - Vector2(Game.get_viewport_dimens().x, Game.get_viewport_dimens().y) / 2)
			#)
