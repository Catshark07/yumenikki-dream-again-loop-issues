extends Event

@export var scene_traversal: SceneTraversal
var interactable: Node2D

func _execute() -> void:
	EventManager.invoke_event("PLAYER_DOOR_USED", [scene_traversal.connection_id])
	Game.change_scene_to(load(scene_traversal.scene_path))

func _validate() -> bool:
	if scene_traversal == null:
		printerr("EVENT - TRAVEL SCENE :: Scene traversal node is not found!")
		return false
		
	if (scene_traversal.spawn_point == null or 
		scene_traversal.scene_path.is_empty() or
		!ResourceLoader.exists(scene_traversal.scene_path)):
		
		printerr("EVENT - TRAVEL SCENE :: Scene traversal node is missing some of its properties!")
		return false
		
	return true
