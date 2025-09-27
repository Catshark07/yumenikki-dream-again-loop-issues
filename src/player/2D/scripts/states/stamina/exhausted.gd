extends State

func _state_enter() -> void: 
	EventManager.invoke_event("PLAYER_EXHAUST")
	Player.Instance.get_pl().is_exhausted = true

func _state_exit() -> void: 
	Player.Instance.get_pl().is_exhausted = false
	Player.Instance.get_pl().stamina = Player.MAX_STAMINA
	Player.Instance.get_pl().sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func _state_physics_update(_delta: float) -> void:
	Player.Instance.get_pl().components.get_component_by_name(Player_YN.COMP_MENTAL).bpm = 120
	if Player.Instance.get_pl().stamina > 0.5 * (Player.MAX_STAMINA): 
		request_transition_to("normal")
