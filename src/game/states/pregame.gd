extends State

func _enter_state() -> void: 
	GameManager.set_control_visibility(GameManager.player_hud, false)
