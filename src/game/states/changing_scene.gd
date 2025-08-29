extends State

func _state_enter() -> void:
	SceneManager.scene_node.process_mode = Node.PROCESS_MODE_DISABLED
