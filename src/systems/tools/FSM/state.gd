class_name State
extends Node

@export var transitionable: bool = true
@export var transitions: Array[State]
var transitions_dict: Dictionary[StringName, State]

var fsm: 		FSM 	# - FSM that owns this state.
var context: 	Node 	# - context / object that this state (and FSM) manipulates.
var parent:		NestedState	# - state that is parent of this state. (if it exists).

signal entered
signal exited

func setup() -> void: 
	if fsm != null: context = fsm.context
	for t in transitions:
		if t == null: continue
		transitions_dict[t.name.to_lower()] = t
	_setup()
	
func _init() -> void:
	set_process(false)
	set_physics_process(false)

func _setup() -> void:	pass
func _enter_state() -> void: pass
func _exit_state() -> void: pass

func physics_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass

func input(_event: InputEvent) -> void: pass

func can_transition_to(_state_id: StringName) -> bool:
	if !transitions_dict.has(_state_id): return false 
	var state = transitions_dict[_state_id]
	
	if state == null: return false
	if state.transitionable and (state.fsm == self.fsm):
		# - this to ensure that the states fsm are from the same state machine
		if state in transitions: return true #  - if this new state is in the current's transitions array...

	return false
func request_transition_to(_state_id: StringName, _force_fsm_priority: bool = false) -> void: 
	if can_transition_to(_state_id):
		if !is_sub_state() or _force_fsm_priority: 
			fsm.change_to_state(_state_id)
		else:				
			parent.set_sub_state(_state_id)
func is_sub_state() -> bool:
	return parent != null
