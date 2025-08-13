extends State


func _enter_state() -> void: GameManager.set_control_visibility(GameManager.player_hud.indicators, true)
func _exit_state() -> void: GameManager.set_control_visibility(GameManager.player_hud.indicators, false)
	
func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_hud_toggle"):GameManager.set_control_visibility(
		GameManager.player_hud.indicators,
		!GameManager.player_hud.indicators.visible)
		
	if Input.is_action_just_pressed("pl_inventory"): 
		EventManager.invoke_event("SPECIAL_INVERT_START_REQUEST")
	
	if Input.is_action_just_pressed("ui_favourite_effect"): 
		(Player.Instance.get_pl() as Player_YN).equip(Player.Instance.equipment_pending)
