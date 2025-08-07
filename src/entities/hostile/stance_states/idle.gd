extends SentientState

func _enter_state() -> void: 
	(sentient as SentientBase).velocity = Vector2.ZERO
	super()

func physics_update(_delta: float) -> void:
	if sentient.speed > 0: fsm.change_to_state("walk")
	
