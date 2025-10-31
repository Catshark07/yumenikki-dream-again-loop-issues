class_name SceneManager 
extends Game.GameSubClass

static var scene_entered: EventListener

static var scene_stack: Stack
static var scene_node: SceneNode

static var curr_scene_resource: PackedScene
static var prev_scene_resource: PackedScene

static var scene_change_pending: bool = false

# ---------- 	BACKGROUND LOADING 		---------- #
static var load_requested: bool = false
static var bg_load_finished: bool = false

static var load_progress: Array[int] = [0]
static var scene_load_err_check: Error
static var scene_load_status: ResourceLoader.ThreadLoadStatus

static var result: ResourceLoader.ThreadLoadStatus

static func handle_scene_resource_load(scene: PackedScene) -> ResourceLoader.ThreadLoadStatus:
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
static func _setup() -> void: 
	scene_stack 		= Stack.new()
	scene_entered 		= EventListener.new(null, "SCENE_TREE_ENTERED")
	scene_entered.do_on_notify(func(): 
		handle_scene_push(EventManager.get_event_param("SCENE_TREE_ENTERED")[0]), 
		"SCENE_TREE_ENTERED")
		
	
# ---------- 	SCENES LOADER / UNLOADERS 		---------- #
static func load_scene(_scene: PackedScene, _push_to_stack: bool = true) -> void:
	if ResourceLoader.exists(_scene.resource_path) and _scene.can_instantiate():
		scene_load_err_check = ResourceLoader.load_threaded_request(_scene.resource_path)
		
		load_requested = true
		bg_load_finished = false
		
		result = await handle_scene_resource_load(_scene)
		
		if result == ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			if _push_to_stack: 
				handle_scene_push(_scene.instantiate())
			
			EventManager.invoke_event("SCENE_LOADED", _scene)
					
		load_requested = false
		bg_load_finished = true
		
		print_rich(str("[color=yellow]SceneManager // Load Status: %s [/color]" % scene_load_status))
		print_rich("[color=yellow]SceneManager // Loading :: Loading Scene was a success![/color]")

	else: curr_scene_resource = null

static func handle_scene_push(_scene_node: SceneNode) -> void:
	# - bail out in case we were already taken care of.
	
	if _scene_node == null or _scene_node.initialized: return
	scene_node = _scene_node
	
	print(_scene_node, "          ---- --- - - - -PUSHED!!!")
	
	prev_scene_resource = curr_scene_resource
	curr_scene_resource = load(_scene_node.scene_file_path) if !_scene_node.scene_file_path.is_empty() else null
	_scene_node.initialize()

	if 		_scene_node.get_parent() == null: GameManager.pausable_parent.add_child(_scene_node)
	else: 	_scene_node.reparent.call_deferred(GameManager.pausable_parent)
	
	EventManager.invoke_event("SCENE_PUSHED", _scene_node)
	
	scene_stack.push(_scene_node)
static func handle_scene_pop() -> void:
	print_rich(str("[color=yellow]SceneManager // Scene Pop: %s [/color]" % scene_stack.pop()))
	EventManager.invoke_event("SCENE_POPPED")
	

static func change_scene_to(_scene: PackedScene, _fade_in: bool = true, _fade_out: bool = true) -> void:
	if _scene == null or !ResourceLoader.exists(_scene.resource_path): 
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")
		return
		
	if scene_node and _scene and _scene != curr_scene_resource:
	
		if !scene_change_pending:
			scene_change_pending = true

			EventManager.invoke_event("SCENE_CHANGE_REQUEST")
			GameManager.change_to_state("CHANGING_SCENES")
			scene_stack.queue_pop()
			if _fade_in: await GameManager.screen_transition.request_transition(ScreenTransition.fade_type.FADE_IN)
			Game.scene_unloaded.emit()
			
			handle_scene_pop()
			await load_scene(_scene)
			Game.scene_loaded.emit()
			
			if _fade_out: GameManager.screen_transition.request_transition(ScreenTransition.fade_type.FADE_OUT)
			GameManager.secondary_transition.fade_progress = 0

			print_rich("[color=green]SceneManager // Scene Change :: Success.[/color]")
			EventManager.invoke_event("SCENE_CHANGE_SUCCESS", _scene.resource_path)
			GameManager.change_to_state(GameManager.game_fsm.prev_state.name)
				
			scene_change_pending = false
			
	else: 
		EventManager.invoke_event("SCENE_CHANGE_FAIL")
		print_rich("[color=yellow]SceneManager // Scene Change :: Scene does not exist. [/color]")


static func _update(_delta: float) -> void: 		if scene_node: scene_node._update(_delta)
static func _physics_update(_delta: float) -> void: if scene_node: scene_node._physics_update(_delta)
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
