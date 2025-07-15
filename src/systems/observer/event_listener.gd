class_name EventListener
extends RefCounted

var events_listening_to: Array[String]

var is_static: bool
var node_owner: Node
var actions: Dictionary

func _init(_id: Array[String] = [""], _static: bool = false, _owner: Node = null) -> void:
	is_static = _static
	node_owner = _owner
	for i in _id:
		listen_to_event(i)

func on_notify(_id: String) -> void: # --- called from the event_manager.
	_id = _id.to_upper()
	if _id in EventManager.event_ids:
		if _id in actions and actions[_id] and (is_instance_valid(node_owner) or is_static): 
			actions[_id].call_deferred()
		
func do_on_notify(_event_id: PackedStringArray = [""], _do := Callable()) -> void: 
	for id in _event_id: 
		id = id.to_upper()
		if id in EventManager.event_ids and id in events_listening_to:
			actions[id] = Callable(_do)

func listen_to_event(_event_id: String):
	_event_id = _event_id.to_upper()
	EventManager.add_listener(self, _event_id)
	events_listening_to.append(_event_id)
		
func is_valid_listener() -> bool:
	return ((is_static and node_owner == null) or (node_owner != null))
