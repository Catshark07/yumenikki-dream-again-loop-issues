class_name SBInputController
extends InputController

var sentient: SentientBase

func _setup(_sb: SentientBase = null) -> void: 
	if _sb == null: return
	sentient 		= _sb
