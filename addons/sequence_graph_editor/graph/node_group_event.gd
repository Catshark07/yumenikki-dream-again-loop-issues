@tool

class_name GRAPH_NODE_GROUP_EVENT
extends GraphNode

var append_node_button: Button
var remove_back_node_button: Button

var events_in_group: Array[GRAPH_NODE_EVENT]

func _init() -> void: 
	append_node_button = Button.new()
	remove_back_node_button = Button.new()
	
	append_node_button.text = "Append Base Event Node."
	remove_back_node_button.text = "Pop Base Event Node."
	
	add_child(append_node_button)
	add_child(remove_back_node_button)
	
	_init_flags()

	set_slot(0, true, 0, Color.WHITE, true, 0, Color.WHITE)
func _init_flags() -> void:
	title = "Empty Grouped Event"
	custom_minimum_size = Vector2i(350, 120)
	resizable = true
	
	append_node_button.pressed.connect(append_event_node)
	remove_back_node_button.pressed.connect(remove_event_node)

func append_event_node() -> void: 
	var pending_node: GRAPH_NODE_EVENT
	pending_node = GRAPH_NODE_EVENT.new()
	pending_node.event_script = preload("res://src/systems/event/event_interface.gd")
	pending_node.set_slot_enabled_left(0, false)
	pending_node.set_slot_enabled_right(0, false)
	add_child(pending_node)
	
	events_in_group.append(pending_node)
	
func remove_event_node() -> void:
	size = Vector2.ZERO

	var delete_node: GRAPH_NODE_EVENT
	delete_node = get_child(events_in_group.size() + 1)
	delete_node.queue_free()
	events_in_group.pop_back()
