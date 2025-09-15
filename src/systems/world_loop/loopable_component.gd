@tool
@icon("res://addons/miscallenous/editor/loopable_component.png")

# - this component will be handled from a different manager.
class_name LoopableComponent
extends Component

@export_tool_button("Setup Loop Component") var setup_pre_game = setup_loop_nodes

const LOOPABLE_ID := &"loop_components"

# - the nodes and their properties.
@export var parent: Node
@export var do_not_dupe: bool = false:
	get:
		if parent == null or !parent is CanvasItem: return true
		return do_not_dupe
@export var dupe_nodes: Array[Node]

@export_group("READ-ONLY")
@export var loop_nodes_dict: Dictionary[Node, Array]

@export var world_size: Vector2i

func _enter_tree() -> void:	
	parent = self.get_parent()
	add_to_group(LOOPABLE_ID)
func _exit_tree() -> void: 	remove_from_group(LOOPABLE_ID)
	
func _update(_delta: float) -> void: pass

func setup_loop_nodes() -> void:
	# - we clear and free the old duplicated nodes list.
	if do_not_dupe: return
	parent = self.get_parent()
	
	for k in dupe_nodes:
		if k != null: k.queue_free()
			
	dupe_nodes.clear()
	
	# - we create the duplicated nodes.
	for i in range(8):
		var potential_dupe = Utils.get_child_node_or_null(self, "loop_%s_%s" % [parent.name, i])
			
			# - if it already exists, then skip it.
		if 		potential_dupe != null and dupe_nodes.has(potential_dupe): continue
		elif 	potential_dupe != null: potential_dupe.queue_free()
			
		potential_dupe = Utils.add_child_node(self, parent.duplicate(0), "loop_%s_%s" % [parent.name, i])
		for c in potential_dupe.get_children(): c.queue_free()
		
		dupe_nodes.append(potential_dupe)

func _validate_property(property: Dictionary) -> void:
	var props_to_hide = ["world_size", "loop_nodes"]
	if 	property.name in props_to_hide:
		property.usage = PROPERTY_USAGE_EDITOR
