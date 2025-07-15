extends State
	
@export var bgm: BGM
@export var inventory: Control

func enter_state() -> void: 
	GameManager.set_cinematic_bars(true)
	Game.scene_manager.get_curr_scene().process_mode = Node.PROCESS_MODE_DISABLED
	
	Game.lerp_timescale(0.5)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
	bgm.play_music()
	if inventory != null: inventory.visible = true
	
func exit_state() -> void: 	
	Game.lerp_timescale(1)
	Game.scene_manager.get_curr_scene().process_mode = Node.PROCESS_MODE_INHERIT
	GameManager.set_cinematic_bars(false)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END")
	Music.play_music_dict(Music.prev_music)
	if inventory != null: inventory.visible = false
