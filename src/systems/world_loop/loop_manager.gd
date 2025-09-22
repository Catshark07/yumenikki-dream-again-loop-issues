@tool
class_name LoopManager
extends Node

@export_group("Loop Component Updates and Setups.")
@export_tool_button("Update Collection and Info.") 	var update_collection := update_loopable_collection
@export_tool_button("Update Loop Duplicates' Properties.") 	var update_loop_objs 	:= update_loopable_components
@export_tool_button("Setup Components.") 	var setup_loop_objs 	:= setup_loopable_components

@export_group("Loop Component Visibility.")
@export_tool_button("Show All Duplicates") var show_dupes
@export_tool_button("Hide All Duplicates") var hide_dupes

const LOOP_UNIT_VECTOR := [
	Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
	Vector2(-1, 0), Vector2(1, 0),
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
]

@export_group("Info.")
@export var loop_objects: Array[Node]
@export var world_size: Vector2:
	set = set_world_size

# - detection nodes.
@export var loop_objects_detect: Area2D
@export var shape_detect: CollisionShape2D

# - signals.
signal update_dupe_nodes

func _ready() -> void: 
	loop_objects_detect	= Utils.get_child_node_or_null(self, "loop_objects_detect")
	
	if 	loop_objects_detect == null:
		
		loop_objects_detect = Utils.add_child_node(self, Area2D.new(), "loop_objects_detect")
		shape_detect 		= Utils.add_child_node(loop_objects_detect, CollisionShape2D.new(), "detect_shape")
		shape_detect.shape = RectangleShape2D.new()
		
		loop_objects_detect.set_collision_mask_value(1, false)
		loop_objects_detect.set_collision_mask_value(7, true)

	shape_detect = Utils.get_child_node_or_null(loop_objects_detect, "detect_shape")
	
func _process(_detla: float) -> void:
	if Engine.is_editor_hint(): (shape_detect.shape as RectangleShape2D).size = world_size
	else: 						update_dupe_nodes.emit()
		
	for loopable: LoopableComponent in loop_objects: 
		if loopable.target is CanvasItem and !loopable.do_not_loop:
			
			loopable.target.global_position.x = wrap(loopable.target.global_position.x, -world_size.x / 2, world_size.x / 2)
			loopable.target.global_position.y = wrap(loopable.target.global_position.y, -world_size.y / 2, world_size.y / 2)
									
func set_world_size(_size: Vector2) -> void:
	world_size = _size.round()
	for loopable: LoopableComponent in loop_objects:
		if 	loopable != null:
			loopable.world_size = _size

# - loop components exclusive.
func update_loopable_collection() -> void: 
	loop_objects = Utils.get_group_arr(LoopableComponent.LOOPABLE_ID)
	for loopable: LoopableComponent in loop_objects:
		if 	loopable != null: 
			loopable.loopable_setup(self)
			Utils.connect_to_signal(update_loopable_collection, loopable.tree_exiting)
func update_loopable_components() -> void: 
	for i: LoopableComponent in loop_objects:
		i.update_duplicates()

func setup_loopable_components() -> void: 
	for i: LoopableComponent in loop_objects:
		i.setup_loop_nodes()

	
