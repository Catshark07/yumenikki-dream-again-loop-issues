class_name HFSM
extends State

signal fsm_changed(_new_state)

var state_fsm_dict: Dictionary
var prev_state_fsm: Node
var curr_state_fsm: Node
@export var initial_state_fsm: Node

func _setup() -> void:
	for state_or_fsm in self.get_children():
		if state_or_fsm is FSM or state_or_fsm is State:
			state_fsm_dict[state_or_fsm.name.to_lower()] = state_or_fsm 
			
			if state_or_fsm is State: 
				state_or_fsm.fsm = self
				state_or_fsm._setup()
			
			if state_or_fsm is FSM: 
				state_or_fsm.setup(self, true)
		
	if initial_state_fsm != null: curr_state_fsm = initial_state_fsm
	else: 
		initial_state_fsm = state_fsm_dict.values()[0]
		curr_state_fsm = initial_state_fsm
		
func _init(_init_state_or_fsm: FSM = null) -> void: 
	super()
	initial_state_fsm = _init_state_or_fsm

# --- fsm helper methods
func _has_state_or_fsm(_name: String) -> bool: return _name in state_fsm_dict

# --- state behaviour
func _enter_state() -> void: 
	super()
	if curr_state_fsm is State: curr_state_fsm._enter_state()
	if curr_state_fsm is FSM: curr_state_fsm._enter()
func _exit_state() -> void: 
	super()
	if curr_state_fsm is State: curr_state_fsm._exit_state()
	if curr_state_fsm is FSM: curr_state_fsm._exit()

func change_to_state_or_fsm(_new: StringName) -> void:
	if (fsm as FSM).get_curr_state() != self: return
	
	if _new != "" and _has_state_or_fsm(_new):
		var new_state_or_fsm: Node = state_fsm_dict.get(_new.to_lower())
		if curr_state_fsm != new_state_or_fsm:
			prev_state_fsm = curr_state_fsm
			
			fsm_changed.emit(new_state_or_fsm)	
			
			curr_state_fsm._exit_state()
			curr_state_fsm = new_state_or_fsm
			curr_state_fsm._enter_state()

func _get_state(state_name: StringName) -> State:
	if curr_state_fsm._has_state(state_name.to_lower()): return curr_state_fsm.state_dict[state_name.to_lower()] 
	return null
func _get_curr_state_or_fsm() -> Node: 
	if curr_state_fsm is FSM: return curr_state_fsm.curr_state
	elif curr_state_fsm is State: return curr_state_fsm
	return
func _get_curr_state_or_fsm_name() -> String:
	if _get_curr_state_or_fsm() is FSM: return curr_state_fsm.state_dict.find_key(curr_state_fsm.curr_state)
	if _get_curr_state_or_fsm() is State: return curr_state_fsm.name
	return str("%s:: no state / fsm bound" % self) 
	
func update(_delta: float) -> void:		 
	if curr_state_fsm != null: 
		if curr_state_fsm is FSM: curr_state_fsm._update(_delta)
		elif curr_state_fsm is State: curr_state_fsm.update(_delta)
func physics_update(_delta: float) -> void: 
	if curr_state_fsm != null: 
		if curr_state_fsm is FSM: curr_state_fsm._physics_update(_delta)
		elif curr_state_fsm is State: curr_state_fsm.physics_update(_delta)
func input(event: InputEvent) -> void: 
	if curr_state_fsm != null: 
		if curr_state_fsm is FSM: curr_state_fsm._input_pass(event)
		elif curr_state_fsm is State: curr_state_fsm.input(event)
	
