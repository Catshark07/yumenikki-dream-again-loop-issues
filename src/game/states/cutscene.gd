extends State

@export var dream_fsm: FSM

func _enter_state() -> void: 
	EventManager.invoke_event("CUTSCENE_START")
	GameManager.set_cinematic_bars(true)

func _exit_state() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	GameManager.set_cinematic_bars(false)
