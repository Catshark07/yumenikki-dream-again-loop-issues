extends Node

const NODE_SAVE_GROUP_ID := &"save_requests"

var data := {
	"scene_path" : {}}

var scene_data_template := {
	"data" 	: {},
	"deleted_nodes_id" : [],
	"instantiated_nodes_id" : [],
	}

func save_scene_data(_scene: SceneNode) -> void: 
	var node_saves: = Utils.get_group_arr(NODE_SAVE_GROUP_ID)
	var scene_path: StringName = _scene.scene_file_path
		
	data[scene_path] = Dictionary(scene_data_template)
	
	for node: SaveRequest in node_saves: 
		if node == null: continue
		var save_dict: Dictionary = node.save_data()
		print(self, save_dict.keys())
		for key in save_dict.keys():
			data[scene_path]["data"][key] = save_dict[key]
				
func load_scene_data(_scene: SceneNode) -> void:
	var node_saves = Utils.get_group_arr(NODE_SAVE_GROUP_ID) as Array[SaveRequest]
	var scene_path: StringName = _scene.scene_file_path
	
	if !data.has(scene_path): return
	if data[scene_path]:
		for node in node_saves: 
			if node != null: node.load_data(_scene)
