extends Component

@export var curr_reality_mode: 	State
@export var dream_mode: 		State
@export var neutral_mode: 		State

const DREAM_LEVEL_DIR := "res://src/levels/_dream"
const REAL_LEVEL_DIR := "res://src/levels/_real"

@onready var scene_changed_listener := EventListener.new(["SCENE_PUSHED"], false, self)

func _setup() -> void:
	scene_changed_listener.do_on_notify(
		["SCENE_PUSHED"], determine_reality_state)

func _enter() -> void:  pass
func _exit() -> void: 
	if curr_reality_mode == null: return
	curr_reality_mode._exit_state()
func _input_pass(event: InputEvent) -> void: 
	if curr_reality_mode != null: curr_reality_mode.input(event)

func determine_reality_state() -> void: 
	if SceneManager.curr_scene_resource == null: return
	
	var scene: String = SceneManager.curr_scene_resource.resource_path
	var scene_dir_path = scene.split("/")
	print(scene_dir_path)
	
	if curr_reality_mode != null:
		curr_reality_mode._exit_state()
	
	if "_dream" in scene_dir_path: 
		EventManager.invoke_event("REALITY_DREAM")
		curr_reality_mode = dream_mode
	else:
		EventManager.invoke_event("REALITY_NEITHER")
		curr_reality_mode = neutral_mode

	curr_reality_mode._enter_state()
