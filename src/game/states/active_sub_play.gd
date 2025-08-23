extends State

@export var dream_component: Component

var sentients_updated: bool = false
var sentients: Array

func _ready() -> void:
	dream_component._setup()
		
func _enter_state() -> void:
	await Game.main_tree.process_frame
	PhysicsServer2D.set_active(true)
	InputManager.request_curr_controller_change(InputManager.sb_input_controller)
	
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s._unfreeze()

	dream_component._enter()
func _exit_state() -> void:
	await Game.main_tree.process_frame
	PhysicsServer2D.set_active(false)
	
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s._freeze()
	
	dream_component._exit()
	
func input(event: InputEvent) -> void:
	dream_component._input_pass(event)
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(true)
