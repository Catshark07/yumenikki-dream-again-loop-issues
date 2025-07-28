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

func enter_state() -> void: entered.emit()
func exit_state() -> void: exited.emit()

func physics_update(_delta: float) -> void: pass
func update(_delta: float) -> void: pass

func input(_event: InputEvent) -> void: pass

# ----

func get_state_str() -> String: return self.name
func can_transition_to(_state: State) -> bool: 
	return _state in transitions and _state.transitionable
