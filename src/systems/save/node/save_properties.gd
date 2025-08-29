class_name NodePropertiesSaver
extends SaveRequest

@export var properties: Array[String]

var parent: Node
var data := {"prop" : {} }

func load_data(_scene: SceneNode) -> Error:
	parent = get_parent()
	if parent == null or properties.is_empty(): return ERR_UNAVAILABLE
		
	var saved_data = NodeSaveService.data[_scene.scene_file_path]

	for prop in saved_data["data"]["prop"]:
		parent.set_indexed(prop, saved_data.get(prop))
			
	return ERR_DOES_NOT_EXIST

func save_data() -> Dictionary:
	parent = get_parent()
	if parent == null or properties.is_empty(): return {}
	
	for p : NodePath in properties: 
		parent.get_indexed(p)
		data["prop"][p] = parent.get_indexed(p)
		
	return data
