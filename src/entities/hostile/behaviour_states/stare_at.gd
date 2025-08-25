extends SBState

var target: SentientBase

func physics_update(_delta: float) -> void:
	if target == null: return
	sentient.handle_direction((target.global_position - sentient.global_position))
