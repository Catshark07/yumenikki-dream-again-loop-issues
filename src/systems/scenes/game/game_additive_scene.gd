@tool

class_name AdditiveGameScene
extends AdditiveScene

@export_storage var scene_load_sequence: Sequence
@export_storage var scene_unload_sequence: Sequence

func _ready() -> void: 
	generate_id()
	
	scene_load_sequence = GlobalUtils.get_child_node_or_null(self, "scene_load_sequence")
	scene_unload_sequence = GlobalUtils.get_child_node_or_null(self, "scene_unload_sequence")
	
	if scene_load_sequence == null: scene_load_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_load_sequence")
	if scene_unload_sequence == null: scene_unload_sequence = await GlobalUtils.add_child_node(self, Sequence.new(), "scene_unload_sequence")
	
	if !Engine.is_editor_hint():
		Game.scene_manager.additive_scene_node = self
	
func _on_load() -> void:
	Game.scene_manager.additive_scene_node = self
	scene_load_sequence._execute()
func _on_unload() -> void: 
	scene_unload_sequence._execute()
