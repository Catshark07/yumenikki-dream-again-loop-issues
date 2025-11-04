@tool

class_name EVN_PlayBGM
extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}

@export var music_bus: MUSIC_BUS
@export var stream: AudioStream

@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

# -- tests

@export_tool_button("Play Test Audio") var play: Callable = play_test_audio
@export_tool_button("Stop Test Audio") var stop: Callable = stop_test_audio

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.		play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.	play_sound(stream, vol, pitch) 

func play_test_audio() -> void:	AudioService.play_sound(stream, vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
