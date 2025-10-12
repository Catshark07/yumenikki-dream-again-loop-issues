extends State

func _state_enter() -> void: 
	GameManager.player_hud.visible = false
	Player.Instance.equipment_favourite = null
