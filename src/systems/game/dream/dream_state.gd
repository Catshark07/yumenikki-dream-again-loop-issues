extends State

func enter_state() -> void: GameManager.set_ui_visibility(true)
func exit_state() -> void: 	GameManager.set_ui_visibility(false)
func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("hud_toggle"):GameManager.set_ui_visibility(!GameManager.ui_parent.visible)
