extends SBState

func _enter_state() -> void: 
	(sentient as SentientBase).velocity = Vector2.ZERO
	super()

func physics_update(_delta: float) -> void:
	if sentient.speed > 0: request_transition_to("walk")
	
