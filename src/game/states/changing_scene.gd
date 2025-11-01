extends State

func _state_enter() -> void:
	SceneManager.scene_node.set_process_mode.call_deferred(Node.PROCESS_MODE_DISABLED)
