extends State


func _enter_state() -> void: GameManager.set_control_visibility(GameManager.player_hud.indicators, true)
func _exit_state() -> void: GameManager.set_control_visibility(GameManager.player_hud.indicators, false)
	
func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_hud_toggle"):GameManager.set_control_visibility(
		GameManager.player_hud.indicators,
		!GameManager.player_hud.indicators.visible)
	if Input.is_action_just_pressed("pl_inventory"): 
		print("eh")
		EventManager.invoke_event("SPECIAL_INVERT_START_REQUEST")
