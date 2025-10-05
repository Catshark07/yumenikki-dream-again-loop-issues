extends SBState


func _state_physics_update(_delta: float) -> void:
	if sentient.speed <= 0: request_transition_to("idle")
	elif sentient.speed > sentient.speed * sentient.speed_multiplier: 
		request_transition_to("sprint")
	
	sentient.speed_multiplier = 1
