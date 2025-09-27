extends NestedState

var active_state_listener: EventListener

func _setup() -> void:
	super()
	active_state_listener = EventListener.new(self, 
		"CUTSCENE_START_REQUEST", "CUTSCENE_END_REQUEST",
		"SPECIAL_INVERT_START_REQUEST", "SPECIAL_INVERT_END_REQUEST")
	
	active_state_listener.do_on_notify( # - switch to PLAY
		func(): set_sub_state("play"), "CUTSCENE_END_REQUEST", "SPECIAL_INVERT_END_REQUEST")
	active_state_listener.do_on_notify( # - switch to CUTSCENE
		func(): set_sub_state("cutscene"), "CUTSCENE_START_REQUEST")
	active_state_listener.do_on_notify( # - switch to INVERT_SCENE
		func(): set_sub_state("special_invert_scene"), "SPECIAL_INVERT_START_REQUEST")
	  
	Player.Instance.setup()

func _enter_sub_state() -> void: 
	set_sub_state("play")
	GameManager.player_hud.visible = true
func _exit_sub_state() -> void:
	super()
	InputManager.request_curr_controller_change(InputManager.def_input_controller)
