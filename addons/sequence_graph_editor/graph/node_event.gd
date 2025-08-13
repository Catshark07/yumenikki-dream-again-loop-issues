@tool

class_name GRAPH_NODE_EVENT
extends GraphNode

var event_script: GDScript:
	set = set_event_script
var event_script_property: EditorResourcePicker
var script_instance: Object

signal event_script_changed(_script)

func _init() -> void: 
	event_script_property = EditorResourcePicker.new()
	event_script_property.base_type = "GDScript"
	add_child(event_script_property)
	
	_init_flags()

	set_slot(0, true, 0, Color.WHITE, true, 0, Color.WHITE)
	#event_script = preload("res://src/systems/event/event_interface.gd")
func _init_flags() -> void:
	title = "Event"
	resizable = true
	custom_minimum_size = Vector2i(280, 10)

	event_script_property.editable = true
	event_script_property.toggle_mode = false
	event_script_property.resource_changed.connect(
		func(_resource): event_script = _resource)

func set_event_script(_script: GDScript ) -> void: 
	event_script_property.edited_resource = _script
	event_script = _script
	update_event_property_info(_script)
	
func update_event_property_info(_event: GDScript) -> void:
	for i in get_children():
		if i is EditorProperty: i.queue_free()
	if _event != null or _event is GDScript: 
		if !_event.is_abstract():
			script_instance = _event.new()
			
			for i in script_instance.get_property_list():
				if i["usage"] == 4102:
			
					var property =  EditorInspector.instantiate_property_editor(
							script_instance,
							i["type"],
							"",
							i["hint"],
							i["hint_string"],
							true)
						
					property.label = i["name"]
					self.add_child(property)
					
		
