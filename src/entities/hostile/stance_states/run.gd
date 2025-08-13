extends SentientState

func physics_update(delta: float) -> void:
	if sentient.desired_speed <= 0: fsm.change_to_state("idle")
	sentient.speed_multiplier = 2
