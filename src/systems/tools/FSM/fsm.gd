class_name FSM 
extends Node

var context: Node

signal state_changed(_new_state)
signal setup

var is_setup: bool = false

var state_dict: Dictionary[StringName, State]
var prev_state: State
var curr_state: State
@export var initial_state: State

func _init(init_state: State = null) -> void: initial_state = init_state

# - initial
func _setup(_owner: Node, _skip_initial_state_setup: bool = false) -> void:
	context = _owner
	
	for states in self.get_children():
		if states is State:
			states.fsm = self 
			state_dict[states.name.to_lower()] = states 
			states.setup()
			
	curr_state = initial_state
	if curr_state != null and !_skip_initial_state_setup: 
		curr_state._enter_state()
func change_to_state(_new: StringName) -> void:
	_new = _new.to_lower()
	if !_new.is_empty() and has_state(_new):
		var new_state: State = state_dict.get(_new.to_lower())

		if curr_state != new_state:
			state_changed.emit(new_state)	
			
			curr_state._exit_state()
			curr_state.exited.emit()
			
			prev_state = curr_state
			curr_state = new_state
			
			curr_state._enter_state()
			curr_state.entered.emit()
			
# - state checks + getter
func has_state(_state_id: StringName) -> bool:
	return _state_id in state_dict
func is_in_state(_state_id: StringName) -> bool:
	return curr_state == state_dict.get(_state_id.to_lower())

func get_state(_state_id: StringName) -> State:
	if has_state(_state_id.to_lower()): return state_dict[_state_id.to_lower()] 
	return
func get_curr_state() -> State: 
	return curr_state
func get_curr_state_name() -> StringName: 
	if get_curr_state() == null: return str("%s:: no state bound" % self)
	return state_dict.find_key(curr_state)

# - dependent update / process
func _update(_delta: float) -> void: 
	if curr_state != null: curr_state.update(_delta)
func _physics_update(_delta: float) -> void: 
	if curr_state != null: curr_state.physics_update(_delta)
func _input_pass(event: InputEvent) -> void: 
	if curr_state != null: curr_state.input(event)
