extends SaveRequest

const DICT_PATH := "values"
@export var values: Dictionary[StringName, Variant]

var parent: Node
var data := {DICT_PATH : {}}

func save_data() -> Dictionary:
	parent = get_parent()
	if parent == null: return {}
	
	for v : StringName in values: 
		data[DICT_PATH][v] = values[v]
	
	return data
