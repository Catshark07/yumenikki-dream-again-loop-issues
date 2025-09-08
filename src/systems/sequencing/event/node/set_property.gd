@tool

extends Event

@export var node: Node
@export var property_name: String = "":
	set(_name): 
		property_name = _name
		if Engine.is_editor_hint():
			property_info = search_property(node, _name)
@export var property_info: Dictionary = {
			"name"			: "default",
			"type"			: TYPE_NIL,
			"hint"			: PROPERTY_HINT_NONE,
			"hint_string"	: "",
			"usage" 		: PROPERTY_USAGE_NONE}

var property_exists_in_node: bool = false
@export_storage var property_value: Variant
@export_storage var new_value: Variant

func _get_property_list():
	var properties = [{
			"name"			: "default",
			"type"			: TYPE_NIL,
			"hint"			: PROPERTY_HINT_NONE,
			"hint_string"	: "",
			"usage" 		: PROPERTY_USAGE_NONE}]
	
	if property_info == {}:
		property_exists_in_node = false 
		return properties
	
	property_exists_in_node = true
	return properties
func _validate_property(property: Dictionary) -> void:
	var adaptable_properties: PackedStringArray = [
		"property_value",
		"new_value"
		]
	if property_exists_in_node:
		if property["name"] in adaptable_properties : 
			property["type"] = property_info["type"]
			property["usage"] = PROPERTY_USAGE_DEFAULT # otherwise we show em.
	else:
		if property["name"] in adaptable_properties : 
			property["usage"] = PROPERTY_USAGE_NONE
			
func search_property(_node: Node, _name: String) -> Dictionary:
	# - lol?
	
	if _node == null: 
		property_exists_in_node = false
		return {}
		
	for i in _node.get_property_list():
		if _name == i["name"]: 
			property_exists_in_node = true
			property_value = node.get(_name)
			new_value = property_value
			return i
	
	property_exists_in_node = false
	return {}

func _execute() -> void:
	node.set_indexed(property_name, new_value)

func _valdiate() -> bool:
	return node != null


		
