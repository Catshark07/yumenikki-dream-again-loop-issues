
@tool

class_name SequenceGraphEditor
extends GraphEdit

static var instance: SequenceGraphEditor

@export var save_data: Button
@export var load_data: Button
@export var reset_data: Button 
@export var add_node_menu: MenuButton

@export var override_data_prompt: ConfirmationDialog
@export var node_context_menu: PopupMenu

var current_data: SequenceData
var current_node: GraphNode

var initial_offset := Vector2(25, 25)
var offset_every_n_node := Vector2(15, 15)
var node_arr: Array[GraphNode]

var start_node: GraphNode

var resource_selected: EditorResourcePicker

var node_type_dict := {
	0 : GRAPH_NODE_EVENT,
	1 : GRAPH_NODE_GROUP_EVENT,
}

func _ready() -> void: 
	instance = self
	
	resource_selected = EditorResourcePicker.new()
	resource_selected.base_type = "SequenceData"
	get_node("panel/v_container").add_child(resource_selected)
	
	GlobalUtils.connect_to_signal(func(_node): current_node = _node, node_selected)
	GlobalUtils.connect_to_signal(func(_node): current_node = null, node_deselected)
	
	GlobalUtils.connect_to_signal(handle_node_instantiation, add_node_menu.get_popup().index_pressed)
	GlobalUtils.connect_to_signal(handle_node_context_menu, node_context_menu.index_pressed)
	GlobalUtils.connect_to_signal(save_graph_data, save_data.pressed)
	GlobalUtils.connect_to_signal(load_graph_data, load_data.pressed)
	GlobalUtils.connect_to_signal(reset_graph_data, reset_data.pressed)
	
	GlobalUtils.connect_to_signal(handle_node_connection, connection_request)
	GlobalUtils.connect_to_signal(handle_node_disconnect, disconnection_request)
	
	print(current_data)
func _exit_tree() -> void:
	instance = null
	if is_queued_for_deletion():
		GlobalUtils.disconnect_from_signal(func(_node): current_node = _node, node_selected)
		GlobalUtils.disconnect_from_signal(func(_node): current_node = null, node_deselected)
		
		GlobalUtils.disconnect_from_signal(handle_node_instantiation, add_node_menu.get_popup().index_pressed)
		GlobalUtils.disconnect_from_signal(handle_node_context_menu, node_context_menu.index_pressed)
		GlobalUtils.disconnect_from_signal(save_graph_data, save_data.pressed)
		GlobalUtils.disconnect_from_signal(load_graph_data.bind(current_data), load_data.pressed)
		GlobalUtils.disconnect_from_signal(reset_graph_data, reset_data.pressed)
		
		GlobalUtils.disconnect_from_signal(handle_node_connection, connection_request)
		GlobalUtils.disconnect_from_signal(handle_node_disconnect, disconnection_request)
func set_data(_data: SequenceData) -> void:
	current_data = _data
	resource_selected.edited_resource = _data

func save_graph_data() -> void: 
	current_data.connections = get_connection_list()
	current_data.node_info.resize(node_arr.size())
	
	for node in range(node_arr.size()):
		var _node = node_arr[node]
		
		current_data.node_info[node] = {
			"name" 							: _node.name,
			"title" 						: _node.title,
			"id" 							: node_type_dict.find_key(_node.get_script()),
			"slot_enabled_right" 			: _node.is_slot_enabled_right(0),
			"slot_enabled_left" 			: _node.is_slot_enabled_left(0),
			"position_x" 					: _node.position_offset.x, 
			"position_y" 					: _node.position_offset.y, }
			
		if _node is GRAPH_NODE_EVENT:
			current_data.node_info[node]["event"] = _node.event_script
func load_graph_data() -> void: 
	await reset_graph_data(true)
	
	for i in current_data.node_info: 
		var node = handle_node_instantiation(i["id"])
		node.name = i["name"]		
		node.title = i["title"]		
		node.set_slot_enabled_right(0, i["slot_enabled_right"])	
		node.set_slot_enabled_left(0, i["slot_enabled_left"])	
		node.position_offset.x = i["position_x"]		
		node.position_offset.y = i["position_y"]	
		
		if i.has("event"): node.event_script = i["event"]
		
	for c in current_data.connections:
		handle_node_connection(c["from_node"], c["from_port"], c["to_node"], c["to_port"])
	
	await RenderingServer.frame_post_draw
	queue_redraw()
func reset_graph_data(_clear: bool = false) -> void: 
	for nodes in node_arr: nodes.queue_free()

	node_arr = []
	if _clear: return
	
	start_node = handle_node_instantiation(0)
	var empty_node = handle_node_instantiation(0)
	
	empty_node.event_script = load("res://src/systems/event/event_interface.gd")
	empty_node.position_offset.x = 500
	
	start_node.set_slot_enabled_left(0, false)
	start_node.event_script = load("res://src/systems/event/event_interface.gd")
	start_node.title = "Start"
	
	connect_node(start_node.name, 0, empty_node.name, 0)

func handle_node_instantiation(_id: int) -> GraphNode: 
	var node: GraphNode = null
	
	node = node_type_dict[_id].new()
	node.position_offset += Vector2(15, 15)
	node_arr.append(node)
	add_child(node)
	
	return node
func handle_node_deletion(_node: GraphNode) -> void: 
	if _node == null: return
	node_arr.remove_at(node_arr.find(_node))
	_node.queue_free()
	
func handle_node_context_menu(_id: int) -> void:
	# id - 0 :: NODE DELETE.
	
	match _id:
		0: handle_node_deletion(current_node)
		1: if current_node != null: current_node.queue_free() 

func handle_node_connection(_from_node: String, _from_port: int, _to_node: String, _to_port: int) -> void:
	connect_node(_from_node, _from_port, _to_node, _to_port)
func handle_node_disconnect(_from_node: String, _from_port: int, _to_node: String, _to_port: int) -> void:
	disconnect_node(_from_node, _from_port, _to_node, _to_port)

static func execute() -> void:
	for event in instance.current_data.connections:
		instance.get_node(event["from_node"]).script_instance._execute()

func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			
			if  current_node != null:  
				if current_node is GRAPH_NODE_EVENT or current_node is GRAPH_NODE_GROUP_EVENT: 
					node_context_menu.popup(Rect2i(get_global_mouse_position(), Vector2.ZERO))
