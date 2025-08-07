extends State

func _enter_state() -> void: 
	EventManager.invoke_event("PLAYER_EXHAUST")
	Player.Instance.get_pl().is_exhausted = true
	Player.Instance.get_pl().quered_exhaust.emit()

func _exit_state() -> void: 
	Player.Instance.get_pl().is_exhausted = false
	Player.Instance.get_pl().stamina = Player.MAX_STAMINA
	Player.Instance.get_pl().sound_player.play_sound(preload("res://src/audio/se/se_breathe.wav"))
	
func physics_update(_delta: float) -> void:
	Player.Instance.get_pl().components.get_component_by_name("mental_status").bpm = 120
	if Player.Instance.get_pl().stamina > 0.5 * (Player.MAX_STAMINA): 
		fsm.change_to_state("normal")
