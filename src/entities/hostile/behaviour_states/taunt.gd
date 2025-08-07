extends SentientState

@export var stance_fsm: SentientFSM
@export var aggression_component: SBAggression

func _enter_state() -> void: 
	#stance_fsm.change_to_state("idle")
	if aggression_component.suspicion >= aggression_component.min_chase_threshold:
		fsm.change_to_state("chase")
	else:
		fsm.change_to_state("observe")
