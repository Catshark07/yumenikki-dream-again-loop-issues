extends State

@export var dream_fsm: FSM

func _enter_state() -> void: 
	EventManager.invoke_event("CUTSCENE_START")
	GameManager.set_cinematic_bars(true)
	GameManager.set_control_visibility(GameManager.player_hud.indicators, false)

func _exit_state() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	GameManager.set_cinematic_bars(false)
