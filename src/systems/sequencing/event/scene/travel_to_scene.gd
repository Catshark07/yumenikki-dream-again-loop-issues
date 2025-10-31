extends Event

@export var scene_traversal: SceneTraversal
@export var skip_spawn_point: bool = false
var interactable: Node2D

func _execute() -> void:
	EventManager.invoke_event("PLAYER_DOOR_USED", scene_traversal.connection_id)
	SceneManager.change_scene_to(load(scene_traversal.scene_path))

func _validate() -> bool:
	if scene_traversal == null:
		printerr("EVENT - TRAVEL SCENE :: Scene traversal node is not found!")
		return false
		
	if (scene_traversal.scene_path.is_empty() or
		!ResourceLoader.exists(scene_traversal.scene_path)):
			
		printerr("EVENT - TRAVEL SCENE :: Scene traversal node is missing some of its properties!")
		return false

	if (scene_traversal.spawn_point == null and !skip_spawn_point):
		printerr("EVENT - TRAVEL SCENE :: Scene traversal node is missing the spawn point object!!")
		return false
		
	return true
