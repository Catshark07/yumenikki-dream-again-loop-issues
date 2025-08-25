class_name NestedState
extends State

var sub_states: Dictionary[StringName, State]
var active: State

func _setup() -> void: 
	for states in self.get_children():
		if states is State:
			states.fsm = fsm
			sub_states[states.name.to_lower()] = states 
			states.setup()
			states.parent = self

func has_sub(_state_id: StringName) -> bool:
	return sub_states.has(_state_id.to_lower())

func _enter_state() -> void: 
	_enter_sub_state()
	if  active != null: 
		active._enter_state()
func _exit_state() -> void: 
	_exit_sub_state()
	if  active != null: 
		active._exit_state()

func physics_update(_delta: float) -> void: 
	_physics_update_sub_state(_delta)
	if  active != null:
		active.physics_update(_delta)
func update(_delta: float) -> void: 
	_update_sub_state(_delta)
	if  active != null:
		active.update(_delta)

# - virtual methods for THIS. its confusing but fuck off.	
func _enter_sub_state() -> void: pass
func _exit_sub_state() -> void: pass

func _physics_update_sub_state(_delta: float) -> void: pass
func _update_sub_state(_delta: float) -> void: pass

# - internal
func set_sub_state(_state_id: StringName) -> void:
	if !has_sub(_state_id): 
		active = null
		return
	
	if active != null: active._exit_state() 		# - previous state
	active = sub_states.get(_state_id.to_lower())
	active._enter_state()							# - new state
