class_name SBInputController
extends InputController

var sentient: SentientBase
var input_component: SBInput

func _setup(_sb: SentientBase = null) -> void: 
	if _sb == null: return
	sentient = _sb
	input_component			= _sb.components.get_component_by_name("input")
	
func _controller_input(_event: InputEvent) -> void: 
	if sentient == null: return
	
	if _event.is_action_pressed("pl_interact"): pass
	if _event.is_action_pressed("pl_sprint"): pass

func _update(_delta: float) -> void:
	if input_component == null: return
	input_component.vel_input = dir_input
	input_component.dir_input = dir_input
