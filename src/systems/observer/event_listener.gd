class_name EventListener
extends RefCounted

var events_listening_to: PackedStringArray

var is_static: bool
var node_owner: Node
var actions: Dictionary

func _init(_owner: Node = null, ..._id: Array) -> void:
	node_owner = _owner
	if node_owner == null or !(node_owner is Node):
		is_static = true
		
	for i in _id:
		listen_to_event(i)

func on_notify(_id: String) -> void: # --- called from the event_manager.
	_id = _id.to_upper()
	if _id in actions and actions[_id] and (node_owner != null or is_static): 
		actions[_id].call()
		
func do_on_notify(_do := Callable(), ..._ids: Array) -> void: 
	for id in _ids:
		if id is String:
			id = id.to_upper()
			if id in events_listening_to:
				actions[id] = Callable(_do)

func listen_to_event(_id: String):
	if 	_id is String:
			
		_id = _id.to_upper()
		events_listening_to.append		(_id)
		EventManager.add_listener(self,  _id)
		
func is_valid_listener() -> bool:
	return ((is_static and node_owner == null) or (node_owner != null))
