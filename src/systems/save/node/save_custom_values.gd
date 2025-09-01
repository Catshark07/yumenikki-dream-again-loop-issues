extends SaveRequest

@export var values: Dictionary[StringName, Variant]
	
	
func load_data(_scene: SceneNode) -> Error:
	var saved_data = NodeSaveService.data[_scene.scene_file_path]["data"]
	
	if !saved_data.has("flags"): return ERR_DOES_NOT_EXIST
	var saved_flags = saved_data["flags"][self.name]
	
	for v: StringName in saved_flags:
		values[v] = saved_flags[v]
	
	return OK
func save_data() -> Dictionary:
	data["flags"] = {}
	data["flags"][self.name] = {}
	
	var flags_dict = data["flags"][self.name]
	
	for v: StringName in values: 
		flags_dict[v] = values[v]
	
	return data
