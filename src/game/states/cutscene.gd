extends State

@export var dream_fsm: FSM

@export var cinematic_ui: CanvasLayer
@export var cinematic_bars: TextureRect
var cb_tween: Tween

#func set_cinematic_bars(_active: bool) -> void: 
	#
	#if cb_tween != null: cb_tween.kill()
	#cb_tween = cinematic_ui.create_tween()
	#cb_tween.set_parallel()
	#cb_tween.set_ease(Tween.EASE_OUT)
	#cb_tween.set_trans(Tween.TRANS_EXPO)
	#
	#match _active:
		#true:
			#cinematic_ui.visible = _active
			#cb_tween.tween_property(cinematic_bars, "size:y", 270, 1)
			#cb_tween.tween_property(cinematic_bars, "position:y", 0, 1)
		#false:
			#cb_tween.tween_property(cinematic_bars, "size:y", 360, 1)
			#cb_tween.tween_property(cinematic_bars, "position:y", -45, 1)
			#await cb_tween.finished
			#cinematic_ui.visible = false
			
func enter_state() -> void: 
	EventManager.invoke_event("CUTSCENE_START")
	GameManager.set_cinematic_bars(true)
	GameManager.set_ui_visibility(false)

func exit_state() -> void: 
	EventManager.invoke_event("CUTSCENE_END")
	GameManager.set_cinematic_bars(false)
	if dream_fsm._get_curr_state_name() == "dream": GameManager.set_ui_visibility(true)
