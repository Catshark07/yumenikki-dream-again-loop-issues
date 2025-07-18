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
		
		if _parent_node == null or _child_node_name.is_empty(): 
			push_warning("Parent is null or Child node could not be found.")
			return null
		return _parent_node.get_node_or_null(_child_node_name)

# OS exclusive
static func print_os(_args = [], _rich: bool = false):
	if OS.is_debug_build(): 
		if _rich: 	print_rich(_args)
		else:		print(_args)

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
static func is_connected_to_signal(_callee: Callable, _signal: Signal) -> bool:
	return _signal.is_connected(_callee)

static func get_group_arr(_name: String) -> Array: 
	var tree: SceneTree
	if Engine.is_editor_hint(): tree = EditorInterface.get_edited_scene_root().get_tree()
	else: tree = Game.get_tree()
	
	if tree.has_group(_name):
		return tree.get_nodes_in_group(_name)
	return []

class Predicate:
	static func evaluate(_expression: bool) -> bool: return _expression
