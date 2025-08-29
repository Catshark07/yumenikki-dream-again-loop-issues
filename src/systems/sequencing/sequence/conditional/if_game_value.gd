extends ConditionalSequence

enum scope {SCENE, GLOBAL}

enum operation {
	EQUALS, 
	NOT_EQUALS, 
	GREATER, 
	GREATER_EQUALS, 
	LESS, 
	LESS_EQUALS}
	
var scene_path
@export var value_scope: scope = scope.SCENE
@export var comparison_operator: operation = operation.EQUALS


func _execute() -> void:
	match value_scope:
		scope.SCENE: 
			var scene_values_dict: Dictionary = NodeSaveService[scene_path]["data"]["values"]
		scope.GLOBAL: pass
		
func _predicate() -> bool: return false

func _validate() -> bool:
	scene_path = owner.scene_file_path
	return scene_path == SceneManager.curr_scene_resource.resource_path
