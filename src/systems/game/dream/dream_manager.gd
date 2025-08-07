extends FSM

const DREAM_LEVEL_DIR := "res://src/levels/_dream"
const REAL_LEVEL_DIR := "res://src/levels/_real"

@onready var scene_changed_listener := EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)

func _setup(_owner: Node, _skip_initial_state_setup: bool = false) -> void:
	super(_owner, _skip_initial_state_setup)
	scene_changed_listener.do_on_notify(
		["SCENE_CHANGE_SUCCESS"], 
		func(): determine_reality_state)
			
	scene_changed_listener.on_notify("SCENE_CHANGE_SUCCESS")

func _enter() -> void:  
	curr_state._enter_state()
	determine_reality_state()
func _exit() -> void: 	curr_state._exit_state()

func determine_reality_state() -> void: 
	if Game.scene_manager.curr_scene_resource == null: return
	
	var scene: String = Game.scene_manager.curr_scene_resource.resource_path
	var scene_folder_path = scene.split("/")
	
	if "_dream" in scene_folder_path: 
		EventManager.invoke_event("REALITY_DREAM")
		change_to_state("dream")
	else:
		EventManager.invoke_event("REALITY_NEITHER")
		print("switching to real state")
		change_to_state("neutral")
