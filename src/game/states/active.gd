extends HFSM

var active_state_listener: EventListener
var events: PackedStringArray = [
	"CUTSCENE_START_REQUEST", "CUTSCENE_END_REQUEST",
	"SPECIAL_INVERT_START_REQUEST", "SPECIAL_INVERT_END_REQUEST",
	]

func _setup() -> void:
	super()
	active_state_listener = EventListener.new(events, false, self)
	
	active_state_listener.do_on_notify( # - switch to PLAY
		["CUTSCENE_END_REQUEST", "SPECIAL_INVERT_END_REQUEST"], func(): change_to_state_or_fsm("play"))
	active_state_listener.do_on_notify( # - switch to CUTSCENE
		["CUTSCENE_START_REQUEST"], func(): change_to_state_or_fsm("cutscene"))
	active_state_listener.do_on_notify( # - switch to INVERT_SCENE
		["SPECIAL_INVERT_START_REQUEST"], func(): change_to_state_or_fsm("special_invert_scene"))
	  
	Player.Instance.setup()

func _enter_state() -> void: 
	super()
	GameManager.player_hud.visible = true
func _exit_state() -> void:
	super()
	InputManager.request_curr_controller_change(InputManager.def_input_controller)
