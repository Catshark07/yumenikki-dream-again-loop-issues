@tool

class_name GameScene
extends SceneNode

@export_group("On Load \\ Free Sequences.")
@export_tool_button("Create On-Initial") var create_initial: Callable 	= create_on_initial
@export_tool_button("Create On-Free") 	 var create_free: Callable 		= create_on_free
@export var seq_initial	: Sequence
@export var seq_free	: Sequence

@export_group("Transitions.")
@export var load_transition: ShaderMaterial = ShaderMaterial.new()
@export var unload_transition: ShaderMaterial = ShaderMaterial.new()

var save_invoker: EventListener
	
# - initial
func _initialize() -> void: 
	
	process_mode = Node.PROCESS_MODE_DISABLED
	save_invoker = EventListener.new(self, "SCENE_CHANGE_REQUEST")
	
	if load_transition == null: 
		load_transition = ShaderMaterial.new()
		load_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")
	if unload_transition == null:
		unload_transition = ShaderMaterial.new()
		unload_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")

# - scene exclusive objects.
# sequences
func create_on_initial() -> void:
	seq_initial = Utils.get_child_node_or_null(self, "on_initial")
	if !Engine.is_editor_hint() or seq_initial != null: return
	
	seq_initial =  Utils.add_child_node(self, Sequence.new(), "on_initial")
	
func create_on_free() -> void:
	seq_free = Utils.get_child_node_or_null(self, "on_free")
	if !Engine.is_editor_hint() or seq_free != null: return
	
	seq_free =  Utils.add_child_node(self, Sequence.new(), "on_free")

# overall control
	
# - stack functions.	
func _on_push() -> void: 
	load_scene()
	save_scene()
	
	process_mode = Node.PROCESS_MODE_INHERIT
	
	for s in Utils.get_group_arr("actors"): 
		if s != null: s._enter()
	
	if seq_initial != null: SequencerManager.invoke(seq_initial)
	process_mode = Node.PROCESS_MODE_INHERIT
func _on_pre_pop() -> void: 
	if seq_free != null: SequencerManager.invoke(seq_free)
	for s in Utils.get_group_arr("actors"): 
		if s != null: s._exit()
func _on_pop() -> void:
	save_scene()
	queue_free()
	process_mode = Node.PROCESS_MODE_DISABLED
	
# - saving. 
func save_scene() -> void: NodeSaveService.save_scene_data(self)
func load_scene() -> void: NodeSaveService.load_scene_data(self)

# - update. 
func _update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._update(_delta)
func _physics_update(_delta: float) -> void:
	for s in Utils.get_group_arr("actors"):
		if s != null:
			if s.can_process(): s._physics_update(_delta)
