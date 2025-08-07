class_name SBInputController
extends InputController

var sentient: SentientBase
var input_component: SBInput

func _setup(_sb: SentientBase = null) -> void: 
	if _sb == null: return
	sentient 		= _sb
	input_component	= _sb.components.get_component_by_name("input")
	
func _unhandled_input(_event: InputEvent) -> void: 
	if sentient == null: return
	
	if sentient is Player:
		if _event.is_action_pressed("pl_interact"):  (sentient as Player).quered_interact.emit()
		
		if _event.is_action_pressed("pl_sprint"): 	 (sentient as Player).quered_sprint_start.emit()
		elif _event.is_action_released("pl_sprint"): (sentient as Player).quered_sprint_end.emit()
		
		if _event.is_action_pressed("pl_sneak"): 	 (sentient as Player).quered_sneak_start.emit()
		elif _event.is_action_released("pl_sneak"):  (sentient as Player).quered_sneak_end.emit()

func _update(_delta: float) -> void:
	if input_component == null: return
	input_component.vel_input = dir_input
	input_component.dir_input = dir_input
