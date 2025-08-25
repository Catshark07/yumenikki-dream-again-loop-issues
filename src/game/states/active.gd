extends NestedState

var active_state_listener: EventListener
var events: PackedStringArray = [
	"CUTSCENE_START_REQUEST", "CUTSCENE_END_REQUEST",
	"SPECIAL_INVERT_START_REQUEST", "SPECIAL_INVERT_END_REQUEST",
	]

func _setup() -> void:
	super()
	active_state_listener = EventListener.new(events, false, self)
	
	active_state_listener.do_on_notify( # - switch to PLAY
		["CUTSCENE_END_REQUEST", "SPECIAL_INVERT_END_REQUEST"], func(): set_sub_state("play"))
	active_state_listener.do_on_notify( # - switch to CUTSCENE
		["CUTSCENE_START_REQUEST"], func(): set_sub_state("cutscene"))
	active_state_listener.do_on_notify( # - switch to INVERT_SCENE
		["SPECIAL_INVERT_START_REQUEST"], func(): set_sub_state("special_invert_scene"))
	  
	Player.Instance.setup()

func _enter_sub_state() -> void: 
	GameManager.player_hud.visible = true
	set_sub_state("play")
func _exit_sub_state() -> void:
	super()
	InputManager.request_curr_controller_change(InputManager.def_input_controller)
