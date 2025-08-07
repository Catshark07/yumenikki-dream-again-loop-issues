class_name SceneManager 
extends RefCounted

signal setup_complete

var scene_stack: Stack
var scene_node: SceneNode
var curr_scene_resource: PackedScene
var prev_scene_resource: PackedScene

var scene_change_pending: bool = false

# ---------- 	BACKGROUND LOADING 		---------- #
var load_requested: bool = false
var bg_load_finished: bool = false

var load_progress: Array[int] = [0]
var scene_load_err_check: Error
var scene_load_status: ResourceLoader.ThreadLoadStatus

var result: ResourceLoader.ThreadLoadStatus

func handle_background_loading_upon_request(scene: PackedScene) -> ResourceLoader.ThreadLoadStatus:
	if scene == null: 
		print("case one")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	if !load_requested or bg_load_finished: 
		print("case two")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	if scene == curr_scene_resource or !ResourceLoader.exists(scene.resource_path): 
		print("case tree")
		return ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED
	
	scene_load_status = ResourceLoader.load_threaded_get_status(scene.resource_path, load_progress)
	
	if scene_load_err_check == OK:
		match scene_load_status:
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE: # - 0
				print_rich("[b]SceneManager // Loading :: Scene (as resource) is invalid. Please check the resource's status.[/b]")
			ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED | ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED: # - 2 or 3
				bg_load_finished = true
	
	return scene_load_status
func setup() -> void: 
	scene_stack = Stack.new()
	for i: SceneNode in GlobalUtils.get_group_arr("scene_node"):
		
		if i.lonely: 
			i.initialize()
			handle_scene_push(i)
		
	setup_complete.emit()
	
# ---------- 	SCENES LOADER / UNLOADERS 		---------- #
func unload_scene(_scene_node: SceneNode) -> bool:
	if _scene_node == null: return false

	await _scene_node.on_unload()
	_scene_node.queue_free()
	EventManager.invoke_event("SCENE_UNLOADED")
	print_rich("[b]SceneManager // Unloading : Scene Unloaded![/b]")
			
	return true 
func load_scene(_scene: PackedScene) -> void:
		
	if ResourceLoader.exists(_scene.resource_path) and _scene.can_instantiate():
		scene_load_err_check = ResourceLoader.load_threaded_request(_scene.resource_path)
		
		load_requested = true
		bg_load_finished = false
		
		result = await handle_background_loading_upon_request(_scene)
		
		if result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			scene_node = _scene.instantiate()
			handle_scene_push(scene_node)
			
			EventManager.invoke_event("SCENE_LOADED")
					
		load_requested = false
		bg_load_finished = true
		
		print(str("SceneManager // Load Status: ", scene_load_status))
		print_rich("[b]SceneManager // Loading :: Loading Scene was a success![/b]")

	else: curr_scene_resource = null

func handle_scene_push(_scene_node: SceneNode) -> void:
	prev_scene_resource = curr_scene_resource
	curr_scene_resource = load(_scene_node.scene_file_path)

	scene_stack.push(_scene_node)
	scene_node = scene_stack.top
	scene_node.initialize()
	
	if scene_node.get_parent() == null:
		GameManager.pausable_parent.add_child(scene_node)
	else:
		scene_node.reparent(GameManager.pausable_parent)
func handle_scene_pop() -> void:
	var scene_to_pop = scene_stack.top
	scene_stack.pop()

func change_scene_to(scene: PackedScene) -> void:
	if !ResourceLoader.exists(scene.resource_path): 
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")
		return
		
	if scene_node and scene and scene != curr_scene_resource:
	
		if !scene_change_pending:
			scene_change_pending = true

			EventManager.invoke_event("SCENE_CHANGE_REQUEST")
			GameManager.change_to_state("CHANGING_SCENES")
			scene_stack.queue_pop()
			await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
			
			handle_scene_pop()
			await load_scene(scene)
			
			GameManager.request_transition(ScreenTransition.fade_type.FADE_OUT)
			print_rich("[color=green]SceneManager // Scene Change :: Success.[/color]")
			EventManager.invoke_event("SCENE_CHANGE_SUCCESS", [scene.resource_path])
				
			scene_change_pending = false
			
	else: 
		EventManager.invoke_event("SCENE_CHANGE_FAIL")
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")

func _update(_delta: float) -> void: if scene_node: scene_node._update(_delta)
func _physics_update(_delta: float) -> void: if scene_node: scene_node._physics_update(_delta)
# ---------- 									---------- #
# ----
# here are the scene events called in order:
#	1. -> SCENE_CHANGE_REQUEST
#			-> called prior to unloading.
#	2. -> SCENE_UNLOADED
#	3. -> SCENE_LOADED
#			-> called prior to loading.
#	4. -> SCENE_CHANGE_SUCESS / SCENE_CHANGE_FAIL
#			-> called after loading.
# ----
