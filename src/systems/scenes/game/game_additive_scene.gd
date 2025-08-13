@tool

class_name AdditiveGameScene
extends SceneNode

@export_storage var scene_load_sequence: Sequence
@export_storage var scene_unload_sequence: Sequence

func _initialize() -> void: 
	scene_load_sequence = GlobalUtils.get_child_node_or_null(self, "scene_load_sequence")
	scene_unload_sequence = GlobalUtils.get_child_node_or_null(self, "scene_unload_sequence")
	
	if scene_load_sequence == null: scene_load_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_load_sequence")
	if scene_unload_sequence == null: scene_unload_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_unload_sequence")
