class_name SentientFSM
extends FSM

var sentient: SentientBase
var animator: Node

func _setup(_sentient: Node = null, _skip_initial_state_setup: bool = false) -> void:
	if _sentient is SentientBase:
		sentient = _sentient
		
		for states in self.get_children():
			if states is SentientState:
				states.fsm = self 
				state_dict[states.name.to_lower()] = states 
				states.sentient = sentient
				states._setup()
				
		curr_state = initial_state
		if curr_state != null: curr_state._enter_state()
