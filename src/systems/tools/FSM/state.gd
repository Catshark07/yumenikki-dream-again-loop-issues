class_name State
extends Node

@export var transitionable: bool = true
@export var transitions: Array[State]

var fsm: Node
var context: Node

signal entered
signal exited

func setup() -> void: 
	if fsm is FSM: context = fsm.context
	_setup()
func _setup() -> void:
	pass
	
func _init() -> void:
	set_process(false)
	set_physics_process(false)

func _enter_state() -> void: pass
func _exit_state() -> void: pass

func physics_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass

func input(_event: InputEvent) -> void: pass

# ----

func get_state_str() -> String: 
	return self.name
func can_transition_to(_state: State) -> bool: 
	if _state.transitionable and (_state.fsm == self.fsm):
		# - this to ensure that the states fsm are from the same state machine
		if _state in transitions: return true #  - if this new state is in the current's transitions array...
		for t in transitions:
			if _state in t.transitions: 
				fsm.change_to_state("t")
				return true # - if this new state is in the current's transitions array...
	
	return false
