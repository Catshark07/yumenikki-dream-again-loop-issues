@tool
@icon("res://addons/miscallenous/editor/loopable_component.png")

# - this component will be handled from a different manager.
class_name LoopableComponent
extends Node2D

@export_tool_button("Setup Loop Component") var setup_pre_game = setup_loop_nodes
@export_tool_button("Refresh Loop Nodes List") var refresh = update_loop_nodes_list

const LOOPABLE_ID := &"loop_components"
@export var manager: LoopManager

# - the nodes and their properties.
@export var target: Node
@export var dupe_nodes: Array[Node]
@export var properties: PackedStringArray 

# - flags.
@export_group("Flags")
@export var do_not_loop:		bool = false
@export var do_not_dupe: 		bool = false:
	get:
		if target == null or !target is CanvasItem: return true
		return do_not_dupe
@export var do_not_update: 		bool = true:
	set(no_update):
		do_not_update = no_update
		if manager == null: return
		if no_update:	 	Utils.disconnect_from_signal(update_duplicates, manager.update_dupe_nodes)
		else:				Utils.connect_to_signal		(update_duplicates, manager.update_dupe_nodes)
@export var keep_child_nodes: 	bool = false
@export var custom_target: 		bool = false

#  - readonly.
@export_group("Read-Only")
@export var loop_nodes_dict: Dictionary[Node, Array]
@export var world_size: Vector2:
	set = __set_size

func loopable_setup(_manager: LoopManager) -> void:
	manager 	= _manager
	world_size 	= _manager.world_size

func _ready() -> void:
	do_not_update = do_not_update
	Utils.connect_to_signal(update_loop_nodes_list, child_order_changed)

func _enter_tree() -> void:	
	Utils.u_add_to_group(self, LOOPABLE_ID)
	if custom_target: return
	target = self.get_parent()
func _exit_tree() -> void: 	
	Utils.u_remove_from_group(self, LOOPABLE_ID)
	
func update_duplicates() -> void: 
	for i in dupe_nodes:
		if i == null or target == null: 
			continue
		
		for p in properties:
			if target.get_indexed(p) == null: continue
			i.set_indexed(p, target.get_indexed(p))	

func setup_loop_nodes() -> void:
	# - we clear and free the old duplicated nodes list.
	var first_dupe: Node = null
	if do_not_dupe: return
	
	dupe_nodes.resize(8)
	
	# - we create the duplicated nodes.
	for i in range(8):
		# - we get any dupes already existent.
		var potential_dupe = Utils.get_child_node_or_null(self, "loop_%s_%s" % [target.name, i])
			
		# - if it already exists, then skip it.
		if 		potential_dupe != null and dupe_nodes.has(potential_dupe): 
			dupe_nodes[i] = (potential_dupe)
		
		# - if it does exist but not in the array, then delete it.	
		elif 	potential_dupe != null: 
			potential_dupe.queue_free()
			continue
		
		if first_dupe != null:
			potential_dupe = Utils.add_child_node(self, first_dupe.duplicate(), "loop_%s_%s" % [target.name, i])
		else:
			potential_dupe = Utils.add_child_node(self, target.duplicate(), "loop_%s_%s" % [target.name, i])
		
		if first_dupe == null: 
			first_dupe = potential_dupe
			
		if !keep_child_nodes:
			for c in potential_dupe.get_children(): c.queue_free()
		
		for c in potential_dupe.get_children(): 
			c.owner = self.owner
			if c.name == self.name: c.free()
		
		dupe_nodes[i] = (potential_dupe)
	update_duplicates()
func update_loop_nodes_list() -> void:
	for i in dupe_nodes:
		if i == null or !is_instance_valid(i): i = null 

# - internal
func __set_size(_size: Vector2) -> void: 
	world_size = _size
	if do_not_dupe: return
	
	for i in range(8):
		if 	dupe_nodes[i] != null:
			dupe_nodes[i].global_position = target.global_position + world_size * manager.LOOP_UNIT_VECTOR[i]

# - editor
func _validate_property(property: Dictionary) -> void:
	var props_to_hide = ["world_size", "loop_nodes"]
	if 	property.name in props_to_hide:
		property.usage = PROPERTY_USAGE_EDITOR
