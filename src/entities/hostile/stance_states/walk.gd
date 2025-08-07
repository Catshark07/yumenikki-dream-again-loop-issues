extends SentientState

func physics_update(_delta: float) -> void:
	if sentient.speed <= 0: fsm.change_to_state("idle")
	elif sentient.speed > sentient.speed * sentient.speed_multiplier: 
		fsm.change_to_state("run")
	
	sentient.speed_multiplier = 1
