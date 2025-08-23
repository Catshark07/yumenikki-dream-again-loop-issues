class_name SBInputController
extends InputController

var sentient: SentientBase

func _setup(_sb: SentientBase = null) -> void: 
	if _sb == null: return
	sentient 		= _sb
	
func _unhandled_input(_event: InputEvent) -> void: 
	if sentient == null: return
	(sentient as Player)._sb_input(_event)
