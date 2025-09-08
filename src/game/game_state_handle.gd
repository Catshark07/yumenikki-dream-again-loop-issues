extends Component

@export var game_state_fsm: FSM
enum states {
	PREGAME, 
	ACTIVE
	}
	
var non_playable_scenes: PackedStringArray = [
	"res://src/levels/_neutral/menu/menu.tscn",
	"res://src/scenes/pre_menu.tscn",
	"res://src/scenes/debug_preload.tscn",
	"res://src/scenes/save/save.tscn"]
var state_requests_listener: EventListener

func _ready() -> void:
	state_requests_listener = EventListener.new(["SCENE_PUSHED"], false, self)
	state_requests_listener.do_on_notify(["SCENE_PUSHED"], update_game_state)
	
func update_game_state() -> void: 
	var curr_res_scene = SceneManager.curr_scene_resource
	var state_id: String = ""
	
	if curr_res_scene == null: return
	if curr_res_scene.resource_path in non_playable_scenes: state_id = "pregame"
	else: state_id = "active"
	
	game_state_fsm.change_to_state(state_id)
