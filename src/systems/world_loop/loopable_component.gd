@tool
@icon("res://addons/miscallenous/editor/loopable_component.png")

# - this component will be handled from a different manager.
class_name LoopableComponent
extends Node2D

@export_tool_button("Setup Loop Component") var setup_pre_game = setup_loop_nodes

const LOOPABLE_ID := &"loop_components"

# - the nodes and their properties.
@export var parent: Node
@export var do_not_dupe: bool = false:
	get:
		if parent == null or !parent is CanvasItem: return true
		return do_not_dupe
@export var dupe_nodes: Array[Node]

@export_group("Properties to Synchronize")
@export var properties: PackedStringArray 

@export_group("READ-ONLY")
@export var loop_nodes_dict: Dictionary[Node, Array]
@export var world_size: Vector2:
	set = __set_size

func _enter_tree() -> void:	
	parent = self.get_parent()
	Utils.u_add_to_group(self, LOOPABLE_ID)
func _exit_tree() -> void: 	
	Utils.u_remove_from_group(self, LOOPABLE_ID)
	
func update_duplicates() -> void: 
	for i in dupe_nodes:
		if i == null or parent == null: continue
		
		for p in properties:
			if parent.get_indexed(p) == null: continue
			i.set_indexed(p, parent.get_indexed(p))	

func setup_loop_nodes() -> void:
	# - we clear and free the old duplicated nodes list.
	parent = self.get_parent()
	Utils.u_add_to_group(self, LOOPABLE_ID)
	if do_not_dupe: return
	
	for k in dupe_nodes:
		if k != null: k.queue_free()
			
	dupe_nodes.clear()
	
	# - we create the duplicated nodes.
	for i in range(8):
		var potential_dupe = Utils.get_child_node_or_null(self, "loop_%s_%s" % [parent.name, i])
			
			# - if it already exists, then skip it.
		if 		potential_dupe != null and dupe_nodes.has(potential_dupe): continue
		elif 	potential_dupe != null: potential_dupe.queue_free()
			
		potential_dupe = Utils.add_child_node(self, parent.duplicate(), "loop_%s_%s" % [parent.name, i])
		for c in potential_dupe.get_children(): c.queue_free()
		
		dupe_nodes.append(potential_dupe)

# - internal

func __set_size(_size: Vector2) -> void: 
	world_size = _size
	if do_not_dupe: return
	
	for i in range(8):
		if 	dupe_nodes[i] != null:
			dupe_nodes[i].global_position = world_size * LoopManager.LOOP_UNIT_VECTOR[i]

# - editor
func _validate_property(property: Dictionary) -> void:
	var props_to_hide = ["world_size", "loop_nodes"]
	if 	property.name in props_to_hide:
		property.usage = PROPERTY_USAGE_EDITOR
