extends SBState

func physics_update(_delta: float) -> void:
	if sentient.speed <= 0: request_transition_to("idle")
	elif sentient.speed > sentient.speed * sentient.speed_multiplier: 
		request_transition_to("run")
	
	sentient.speed_multiplier = 1
