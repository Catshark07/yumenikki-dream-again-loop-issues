extends SBState

@export var stance_fsm: SentientFSM
@export var sb_aggression: SBAggression

func _state_enter() -> void: 
	#stance_fsm.change_to_state("idle")
	if sb_aggression.suspicion >= sb_aggression.min_chase_threshold:
		request_transition_to("chase")
	else:
		request_transition_to("observe")
