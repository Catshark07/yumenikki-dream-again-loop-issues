extends SentientState

@export var stance_fsm: SentientFSM
@export var sb_aggression: SBAggression

func _enter_state() -> void: 
	#stance_fsm.change_to_state("idle")
	if sb_aggression.suspicion >= sb_aggression.min_chase_threshold:
		fsm.change_to_state("chase")
	else:
		fsm.change_to_state("observe")
