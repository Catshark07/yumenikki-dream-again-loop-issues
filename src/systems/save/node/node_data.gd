class_name SaveRequest
extends Node

var data: Dictionary = {}
@export var global: bool = false

func _ready() -> void:
	add_to_group(NodeSaveService.NODE_SAVE_GROUP_ID)
	
func save_data() 					-> Dictionary: return {}
func load_data(_scene: SceneNode) 	-> Error: return OK
