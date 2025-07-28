class_name SBInput
extends SBComponent

var dir_input: Vector2
var vel_input: Vector2
var interaction_manager: SBComponent

func _setup(_sb: SentientBase) -> void: 
	super(_sb)
	if _sb is Player: 
		InputManager.sb_input_controller._setup(_sb)

func _update(_delta: float) -> void: 
	sentient.vel_input = vel_input
	sentient.dir_input = dir_input
