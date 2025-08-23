extends Component

@export var active_state: HFSM

var state_requests_listener: EventListener

func _ready() -> void:
	state_requests_listener = EventListener.new(["SCENE_PUSHED"], false, self)
	state_requests_listener.do_on_notify(["SCENE_PUSHED"], update_game_state)
	
func update_game_state() -> void: 
	var curr_res_scene = SceneManager.curr_scene_resource
	var state_id: String = ""
	
	if curr_res_scene == null: return
	
	active_state.change_to_state_or_fsm(state_id)
