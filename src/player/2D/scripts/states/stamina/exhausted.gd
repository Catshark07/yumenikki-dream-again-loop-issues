extends SBState

func _state_enter() -> void: 
	EventManager.invoke_event("PLAYER_EXHAUST")
	sentient.is_exhausted = true
	sentient.can_sprint = false

func _state_exit() -> void: 
	sentient.is_exhausted = false
	sentient.can_sprint = true
	sentient.stamina = Player.MAX_STAMINA
	sentient.sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func _state_physics_update(_delta: float) -> void:
	sentient.components.get_component_by_name(Player_YN.COMP_MENTAL).bpm = 120
	if sentient.stamina > 0.5 * (Player.MAX_STAMINA): 
		request_transition_to("normal")
