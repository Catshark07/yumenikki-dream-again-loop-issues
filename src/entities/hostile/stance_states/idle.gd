extends SBState

func _state_enter() -> void: 
	(sentient as SentientBase).velocity = Vector2.ZERO
	super()

func _state_physics_update(_delta: float) -> void:
	if sentient.speed > 0: request_transition_to("walk")
	
