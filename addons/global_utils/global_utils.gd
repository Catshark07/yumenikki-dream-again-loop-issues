@tool
class_name GlobalUtils
extends EditorPlugin

func _handles(object: Object) -> bool:
	return object is Node

static func is_within_exclusive(_num: float, _min: float, _max: float) -> bool:
	return ((_num < _min) and (_num > _max))
static func is_within_inclusive(_num: float, _min: float, _max: float) -> bool:
		return ((_num <= _min) and (_num >= _max))

# editor-hint exclusive
static func add_child_node(
	_parent_node: Node,
	_child_node: Node,
	_child_node_name: String) -> Node:
		var _owner: Node
		
		if _child_node == null or _parent_node == null: return
		
		if Engine.is_editor_hint(): _owner = EditorInterface.get_edited_scene_root()
		else: _owner = _parent_node.owner
		
		if !_parent_node.has_node(_child_node_name):
			
			if Engine.is_editor_hint(): 
				await EditorInterface.get_edited_scene_root().get_tree().process_frame
			_parent_node.add_child(_child_node)
			_child_node.name = _child_node_name
			_child_node.owner = _owner
			
			return _child_node
		else:
			push_warning("Parent %s already has child... Freeing %s." % [_parent_node, _child_node])
			_child_node.queue_free()
			return _parent_node.get_node(_child_node_name)
		return
static func get_child_node_or_null(
	_parent_node: Node, 
	_child_node_name: String) -> Node: 
		var _owner: Node
		var _child_node: Node
		
		if _parent_node == null: return null
		return _parent_node.get_node_or_null(_child_node_name)

# runtime exclusive
static func connect_to_signal(
	_conectee: Callable, 
	_signal: Signal, 
	_flags: Object.ConnectFlags = 0, 
	_allow_lambda: bool = true) -> void:
		
	if _signal.is_connected(_conectee): 
		push_warning("GLOBAL UTILS: Callable %s is already connected to signal." % [_conectee])
		return
	
	if !_allow_lambda:
		if 	_conectee.get_object() == null: 
			push_warning("GLOBAL UTILS: Lambda callable %s restricted from connecting to signal." % [_conectee])
			return
			
	_signal.connect(_conectee, _flags)
static func disconnect_from_signal(
	_conectee: Callable,
	_signal: Signal) -> void:
		if !_signal.is_connected(_conectee): 
			push_warning("GLOBAL UTIL: Callable not connected to signal!")
			return
		_signal.disconnect(_conectee)

class Predicate:
	static func evaluate(_expression: bool) -> bool: return _expression
