@tool
extends SoundPlayer

func _ready() -> void:
	super()
	bus = "Master"
	
func _notification(what: int) -> void: 
	if 	what == NOTIFICATION_WM_WINDOW_FOCUS_IN or \
		what == NOTIFICATION_WM_WINDOW_FOCUS_OUT:
		stop()

func play_test_audio_from(
	_bus_name: String,
	_stream: AudioStream, 
	_vol: float = 1, 
	_pitch: float = 1) -> void:
		if Audio.has_bus_name(_bus_name): bus = _bus_name
		play_sound(_stream, _vol, _pitch)
	
