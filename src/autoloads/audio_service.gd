@tool
extends SoundPlayer

func _ready() -> void:
	super()
	bus = "Master"
	
func _notification(what: int) -> void: 
	if 	what == NOTIFICATION_WM_WINDOW_FOCUS_IN or \
		what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		stop()
