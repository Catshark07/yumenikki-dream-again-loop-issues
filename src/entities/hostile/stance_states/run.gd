extends SBState

func physics_update(delta: float) -> void:
	if sentient.desired_speed <= 0: request_transition_to("idle")
	sentient.speed_multiplier = 2
