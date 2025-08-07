extends State
	
@export var inventory: Control

func _enter_state() -> void: 
	Ambience.mute()
	GameManager.set_cinematic_bars(true)
	GameManager.set_control_visibility(GameManager.player_hud, true)
	Game.scene_manager.scene_node.process_mode = Node.PROCESS_MODE_DISABLED
	
	GameManager.set_control_visibility(GameManager.player_hud.inv, true)
	Game.lerp_timescale(0.5)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
	
	if inventory != null: inventory._enter()
func _exit_state() -> void: 	
	Ambience.unmute()
	Game.lerp_timescale(1)
	Game.scene_manager.scene_node.process_mode = Node.PROCESS_MODE_INHERIT
	
	GameManager.set_cinematic_bars(false)
	GameManager.set_control_visibility(GameManager.player_hud.inv, false)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END")
	
	if inventory != null: inventory._exit()

func input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pl_inventory"): EventManager.invoke_event("SPECIAL_INVERT_END_REQUEST")
