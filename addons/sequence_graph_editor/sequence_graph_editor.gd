@tool
extends EditorPlugin

var graph_edit_control: SequenceGraphEditor
var graph_edit_path := "res://addons/sequence_graph_editor/graph/graph.tscn"
var current_edited_sequence: SequenceData

var bottom_panel: Control

func _enter_tree() -> void: 
	graph_edit_control = load(graph_edit_path).instantiate()
	bottom_panel = add_control_to_bottom_panel(graph_edit_control, "Sequence Graph Editor")
	bottom_panel = bottom_panel.get_parent().get_child(bottom_panel.get_index())
func _exit_tree() -> void: 	
	remove_control_from_bottom_panel(graph_edit_control)
	graph_edit_control.free()

func _handles(object: Object) -> bool:
	var is_sequence_data: bool = object is SequenceData
	
	if is_sequence_data: 
		bottom_panel.visible = true	
		current_edited_sequence = object
		graph_edit_control.set_data(object)
		print(graph_edit_control.current_data)
	else: 
		bottom_panel.visible = false	
		current_edited_sequence = null
	
	return is_sequence_data


func _apply_changes() -> void: OS.low_processor_usage_mode = true
func _build() -> bool: 
	OS.low_processor_usage_mode = false
	return true
	
