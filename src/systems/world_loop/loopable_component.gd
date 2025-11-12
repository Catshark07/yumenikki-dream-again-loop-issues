@tool
@icon("res://addons/miscallenous/editor/loopable_component.png")

# - this component will be handled from a different manager.
class_name LoopableComponent
extends Node2D

@export_tool_button("Setup Loop Component") var setup_pre_game = setup_loop_nodes
@export_tool_button("Update Properties") var update_props = update_duplicates

const LOOPABLE_ID := &"loop_components"
@export var manager: LoopManager
@export_storage var idx: int = 0

# - the nodes and their properties.
@export_group("Target and Properties Info")
@export var target: Node
@export var children: Array[Node]
@export var properties: PackedStringArray 

@export_group("Duplicates and Occlusion Array")
@export var dupe_nodes: Array[Node]
@export var occlusions: Array[VisibleOnScreenNotifier2D]

# - flags.
@export_group("Flags")
@export var do_not_loop:				bool = false
@export var do_not_dupe: 				bool = false:
	get:
		if target == null or !target is CanvasItem: return true
		return do_not_dupe
@export var do_not_update: 				bool = true:
	set(no_update):
		do_not_update = no_update
		if manager == null: return
		if no_update:	 	Utils.disconnect_from_signal(update_duplicates, manager.update_dupe_nodes)
		else:				Utils.connect_to_signal		(update_duplicates, manager.update_dupe_nodes)
@export var do_not_include_occlusions: 	bool = false

@export var keep_child_nodes: 			bool = false

#  - readonly.
@export_group("Read-Only")
@export var world_size: Vector2:
	set = __set_size

# - signals

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			if 	manager != null:
				manager.loop_objects[idx] = null

func loopable_setup(_manager: LoopManager) -> void:
	manager 	= _manager

func _ready() -> void:
	self.y_sort_enabled = true
	do_not_update = do_not_update
	
func _enter_tree() -> void:	
	Utils.u_add_to_group(self, LOOPABLE_ID)
	target 		= self.get_parent()
	children 	= target.get_children()
	children.remove_at(children.find(self))
	
func _exit_tree() -> void: 	
	Utils.u_remove_from_group(self, LOOPABLE_ID)
		
func setup_loop_nodes() -> void:
	# - we clear and free the old duplicated nodes list.
	if do_not_dupe or !(target is CanvasItem) : return
	children 	= target.get_children()
	children.remove_at(children.find(self))
	
	var first_dupe: Node = null
	dupe_nodes.resize(8)
	occlusions.resize(8)
	
	# - we create the duplicated nodes.
	for i in range(8):
		# - we get any dupes already existent.
		# - if it already exists, then skip it.
		var potential_dupe = Utils.get_child_node_or_null(self, "loop_%s_%s" % [target.name, i])
		if 		potential_dupe != null and dupe_nodes.has(potential_dupe): 	continue
		elif 	potential_dupe != null: dupe_nodes[i] = potential_dupe; 	continue
		
		# -- 
		if 	first_dupe == null:
			first_dupe = Utils.add_child_node(self, target.duplicate(), "loop_%s_%s" % [target.name, i])
			potential_dupe = first_dupe
		else:
			potential_dupe = Utils.add_child_node(self, first_dupe.duplicate(), "loop_%s_%s" % [target.name, i])
			
		
		if !keep_child_nodes: for c in potential_dupe.get_children(): c.queue_free() 
		else: 
			var potential_duped_loop = potential_dupe.get_node_or_null(str(self.name))
			if	potential_duped_loop in potential_dupe.get_children(): 
				potential_duped_loop.queue_free()
				
		for c in potential_dupe.get_children(): 
			c.owner = self.owner
			c.set_meta("_edit_lock_", true)
			
		dupe_nodes[i] = potential_dupe
		dupe_nodes[i].set_meta("_edit_lock_", true)
		
	if !do_not_include_occlusions:
		for i in range(8):
			if 	dupe_nodes[i] != null:
				occlusions[i] = Utils.add_child_node(dupe_nodes[i], VisibleOnScreenEnabler2D.new(), "occlusion")
				occlusions[i].rect.size = world_size * 1.25
				occlusions[i].rect.position = -occlusions[i].rect.size / 2
				Utils.connect_to_signal(func(): occlusions[i] = null, occlusions[i].tree_exited)
				
	update_duplicates()
	
func update_duplicates() -> void: 
	for i in range(dupe_nodes.size()):
		var dupe_node = dupe_nodes[i]
		
		if children.size() > 0: 
			for c in children.size():
				var child = Utils.get_child_node_or_null(dupe_node, children[c].name)
				for p in properties:
					if child.get_indexed(p) == null: continue
					child.set_indexed(p, children[c].get_indexed(p))
				
		else:
			
			for p in properties:
				if target.get_indexed(p) == null: continue
				dupe_node.set_indexed(p, target.get_indexed(p))	
			
			if !do_not_include_occlusions:
				if occlusions[i] == null: continue
				occlusions[i].rect.size = world_size * 1.25
				occlusions[i].rect.position = -occlusions[i].rect.size / 2

func update_loop_nodes_list(_loop_node) -> void:
	if _loop_node in dupe_nodes:
		dupe_nodes[dupe_nodes.find(_loop_node)] = null

# - internal
func __set_size(_size: Vector2) -> void: 
	world_size = _size
	if do_not_dupe: return
	
	for i in dupe_nodes.size():
		if 	dupe_nodes[i] != null:
			dupe_nodes[i].global_position = target.global_position + world_size * manager.LOOP_UNIT_VECTOR[i]
