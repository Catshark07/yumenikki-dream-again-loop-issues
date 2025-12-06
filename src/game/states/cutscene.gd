extends State

@export var dream_fsm: FSM

func _state_enter() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	EventManager.invoke_event("CUTSCENE_START")
	GameManager.set_cinematic_bars(true)

func _state_exit() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	GameManager.set_cinematic_bars(false)
