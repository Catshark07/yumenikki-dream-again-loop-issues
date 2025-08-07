extends Component

@export var game_state_fsm: FSM
@export var play_mode_fsm: HFSM

var state_requests_listener: EventListener

@export var non_playable_scenes: PackedStringArray = [
	"res://src/levels/_neutral/menu/menu.tscn",
	"res://src/scenes/pre_menu.tscn",
	"res://src/scenes/debug_preload.tscn",
	"res://src/scenes/save/save.tscn"
]
func _ready() -> void: 
	state_requests_listener = EventListener.new(
		["SPECIAL_INVERT_START_REQUEST", "SPECIAL_INVERT_END_REQUEST", 
		"CUTSCENE_START_REQUEST", "CUTSCENE_END_REQUEST"], 
		false, self)
	
	state_requests_listener.do_on_notify(
		["SPECIAL_INVERT_START_REQUEST"], func(): play_mode_fsm.change_to_state_or_fsm("special_invert_scene"))
	state_requests_listener.do_on_notify(
		["CUTSCENE_START_REQUEST"], func(): play_mode_fsm.change_to_state_or_fsm("cutscene"))
	
	state_requests_listener.do_on_notify(
		["SPECIAL_INVERT_END_REQUEST", 
		"CUTSCENE_END_REQUEST"], func(): play_mode_fsm.change_to_state_or_fsm("play")) #?
	
func _setup() -> void:
	game_state_fsm._setup(self)
	
	var initial_scene = Game.scene_manager.curr_scene_resource
	print(initial_scene)
	if initial_scene == null: return
	if initial_scene.resource_path in non_playable_scenes: 
		game_state_fsm.change_to_state("pregame")
	else: game_state_fsm.change_to_state("active")
	
func _update(_delta: float) -> void: game_state_fsm._update(_delta)
func _physics_update(_delta: float) -> void: game_state_fsm._physics_update(_delta)
func _input_pass(_event: InputEvent) -> void: game_state_fsm._input_pass(_event)
