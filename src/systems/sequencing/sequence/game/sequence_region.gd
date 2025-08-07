@tool

class_name SequenceRegion
extends Node

@export var enter_sequence: Sequence
@export var exit_sequence: Sequence

func _ready() -> void:
	var area_region = get_parent()
	
	enter_sequence = GlobalUtils.get_child_node_or_null(self, "enter")
	exit_sequence = GlobalUtils.get_child_node_or_null(self, "exit")
	
	if enter_sequence == null: enter_sequence = GlobalUtils.add_child_node(self, Sequence.new(), "enter")
	if exit_sequence == null: exit_sequence = GlobalUtils.add_child_node(self, Sequence.new(), "exit")
	
	if area_region != null and area_region is AreaRegion:
		
		(area_region as AreaRegion).player_enter_handle.connect(func(_pl): enter_sequence._execute())
		(area_region as AreaRegion).player_exit_handle.connect(func(_pl): exit_sequence._execute())

	process_mode = Node.PROCESS_MODE_DISABLED
