extends State

@export var dream_component: Component
@export var player_global_components: ComponentReceiver

var sentients_updated: bool = false
var sentients: Array

func _ready() -> void:
	dream_component._setup()
		
func _enter_state() -> void:
	await Game.main_tree.process_frame
	
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s.unfreeze()
	PhysicsServer2D.set_active(true)
	InputManager.request_curr_controller_change(InputManager.sb_input_controller)
	dream_component._enter()
	
	player_global_components.set_bypass(false)
func _exit_state() -> void:
	await Game.main_tree.process_frame
	
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s.freeze()
	PhysicsServer2D.set_active(false)
	dream_component._exit()
	
	player_global_components.set_bypass(true)
	
func input(event: InputEvent) -> void:
	dream_component._input_pass(event)
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(true)
