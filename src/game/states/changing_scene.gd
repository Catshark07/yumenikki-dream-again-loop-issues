extends State

func _state_enter() -> void:
	GameManager.set_cinematic_bars(true)
	
	for s in Utils.get_group_arr("actors"): 
		if s != null: s._freeze()
		
	SceneManager.scene_node.set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)

func _state_exit() -> void:
	GameManager.set_cinematic_bars(false)
