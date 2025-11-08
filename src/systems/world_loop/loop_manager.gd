@tool
@icon("res://addons/miscallenous/editor/loop_manager.png")

class_name LoopManager
extends Node2D

@export_group("Loop Component Updates and Setups.")
@export_tool_button("Update Collection.") 					var update_loopables_collection := update_loopable_collection
@export_tool_button("Update Loop Duplicate Info.") 			var update_loopables_world_size := update_loopable_world_size
@export_tool_button("Update Loop Duplicates' Properties.") 	var update_loopables  			:= update_loopable_components
@export_tool_button("Setup Components.") 					var setup_loopables  	 		:= setup_loopable_components

@export_group("Drawing Options.")
@export var draw_colour: Color = Color(Color.PALE_VIOLET_RED, 0.2)
@export_tool_button("Update Boundaries Draw.") 				var redraw   := 	redraw_boundaries

#@export_group("Loop Component Visibility.")
#@export_tool_button("Show All Duplicates") var show_dupes
#@export_tool_button("Hide All Duplicates") var hide_dupes

const LOOP_UNIT_VECTOR := [
	Vector2(-1, -1), Vector2(0, -1), Vector2(1, -1),
	Vector2(-1, 0), Vector2(1, 0),
	Vector2(-1, 1), Vector2(0, 1), Vector2(1, 1)
]

const SAFE_ZONE = Vector2(550, 350)

@export_group("Info.")
@export var loop_objects: Array[Node]
@export var world_size: Vector2 = Vector2(100, 100):
	set = set_world_size

# - detection nodes.
@export var loop_objects_detect: Area2D
@export var shape_detect: CollisionShape2D

# - signals.
signal update_dupe_nodes

func redraw_boundaries() -> void: 
	shape_detect.queue_redraw()

# -- 
func _ready() -> void: 
	loop_objects_detect	= Utils.get_child_node_or_null(self, "loop_objects_detect")
	
	if 	loop_objects_detect == null:
		
		loop_objects_detect = Utils.add_child_node(self, Area2D.new(), "loop_objects_detect")
		shape_detect 		= Utils.add_child_node(loop_objects_detect, CollisionShape2D.new(), "detect_shape")
		shape_detect.shape = RectangleShape2D.new()
		
		loop_objects_detect.set_collision_mask_value(1, false)
		loop_objects_detect.set_collision_mask_value(7, true)

	shape_detect = Utils.get_child_node_or_null(loop_objects_detect, "detect_shape")
	loop_objects_detect.set_meta("_edit_lock_", true)
	shape_detect.		set_meta("_edit_lock_", true)
	
	var draw_safe_zone = func draw_safezone(): 
		if Engine.is_editor_hint():
			shape_detect.draw_rect(
				Rect2(
					-(world_size + SAFE_ZONE * 2) / 2, 
					world_size + SAFE_ZONE * 2), draw_colour)
	
	Utils.connect_to_signal(
		draw_safe_zone, shape_detect.draw)
	
func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint(): (shape_detect.shape as RectangleShape2D).size = world_size
	else: 						update_dupe_nodes.emit()
		
	for loopable: LoopableComponent in loop_objects: 
		if loopable == null: continue
		if loopable.target is CanvasItem and !loopable.do_not_loop:
			
			var min_pos = -world_size / 2 + self.global_position
			var max_pos =  world_size / 2 + self.global_position
			
			loopable.target.global_position.x = wrap(loopable.target.global_position.x, min_pos.x, max_pos.x)
			loopable.target.global_position.y = wrap(loopable.target.global_position.y, min_pos.y, max_pos.y)
									
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
func update_loopable_world_size() -> void:
	set_world_size.call_deferred(world_size)

	
func update_loopable_components() -> void: 
	update_dupe_nodes.emit()

func setup_loopable_components() -> void: 
	for i: LoopableComponent in loop_objects:
		i.setup_loop_nodes()
		set_world_size(world_size)

	
