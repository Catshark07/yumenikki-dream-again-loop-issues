extends State

@export var dream_manager: FSM
@export var dream_manager_setup: bool = false
@export var player_global_components: ComponentReceiver

var sentients_updated: bool = false
var sentients: Array

func _ready() -> void:
	if !dream_manager_setup:
		dream_manager_setup = true
		dream_manager._setup(self)
		
func _enter_state() -> void:
	await Game.main_tree.process_frame
	
	for s in GlobalUtils.get_group_arr("sentients"): 
		if s != null: s.unfreeze()
	PhysicsServer2D.set_active(true)
	InputManager.request_curr_controller_change(InputManager.sb_input_controller)
	dream_manager._enter()
	
	player_global_components.set_bypass(false)
		
func _exit_state() -> void:
	await Game.main_tree.process_frame
	
	for s in GlobalUtils.get_group_arr("sentients"): 
		if s != null: s.freeze()
	PhysicsServer2D.set_active(false)
	InputManager.request_curr_controller_change(InputManager.def_input_controller)
	dream_manager._exit()
	
	player_global_components.set_bypass(true)
	
	dream_manager_setup = false

func input(event: InputEvent) -> void:
	dream_manager._input_pass(event)
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(true)
