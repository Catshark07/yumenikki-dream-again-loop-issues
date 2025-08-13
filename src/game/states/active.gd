extends HFSM

var player_setup: bool = false

func _setup() -> void:
	super()
	if player_setup == false: 
		Player.Instance.setup()
		player_setup = true
		
func _enter_state() -> void: 
	super()
	GameManager.set_control_visibility(GameManager.player_hud, true)
func _exit_state() -> void:
	super()
	InputManager.request_curr_controller_change(InputManager.def_input_controller)
