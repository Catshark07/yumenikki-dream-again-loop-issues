@tool

class_name GameScene
extends SceneNode

@export_storage var scene_load_sequence: Sequence
@export_storage var scene_unload_sequence: Sequence

var save_invoker: EventListener
@export var load_transition: ShaderMaterial = ShaderMaterial.new()
@export var unload_transition: ShaderMaterial = ShaderMaterial.new()

func _initialize() -> void: 
	save_invoker = EventListener.new(["SCENE_CHANGE_REQUEST"], false, self)
	
	scene_load_sequence = GlobalUtils.get_child_node_or_null(self, "scene_load_sequence")
	scene_unload_sequence = GlobalUtils.get_child_node_or_null(self, "scene_unload_sequence")

	if load_transition == null: 
		load_transition = ShaderMaterial.new()
		load_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")
	if unload_transition == null:
		unload_transition = ShaderMaterial.new()
		unload_transition.material = preload("res://src/shaders/transition/tr_fade.gdshader")
		
	if Engine.is_editor_hint():
		if !scene_load_sequence: 	scene_load_sequence = 	GlobalUtils.add_child_node(self, Sequence.new(), "scene_load_sequence")
		if !scene_unload_sequence: 	scene_unload_sequence = GlobalUtils.add_child_node(self, Sequence.new(), "scene_unload_sequence")
	
	if !Engine.is_editor_hint():
		GameManager.screen_transition.set_fade_out_shader(load_transition)
		GameManager.screen_transition.set_fade_in_shader(unload_transition)
		save_invoker.do_on_notify(["SCENE_CHANGE_REQUEST"], save_scene)
		
func _on_push() -> void: 
	for s in GlobalUtils.get_group_arr("sentients"): 
		if s != null: s._enter()

	load_scene()
	save_scene()
	
	if scene_load_sequence != null: await scene_load_sequence.execute()
	process_mode = Node.PROCESS_MODE_INHERIT
func _on_pre_pop() -> void: 
	if scene_unload_sequence != null: await scene_unload_sequence.execute() 
	for s in GlobalUtils.get_group_arr("sentients"): 
		if s != null: s._exit()

func _on_pop() -> void:
	queue_free()
	process_mode = Node.PROCESS_MODE_DISABLED
	
# ---- saving. 
func save_scene() -> void: NodeSaveService.save_scene_data(self)
func load_scene() -> void: NodeSaveService.load_scene_data(self)

func _update(_delta: float) -> void:
	for s in GlobalUtils.get_group_arr("sentients"):
		if s != null:
			if s.can_process(): s._update(_delta)
func _physics_update(_delta: float) -> void:
	for s in GlobalUtils.get_group_arr("sentients"):
		if s != null:
			if s.can_process(): s._physics_update(_delta)
