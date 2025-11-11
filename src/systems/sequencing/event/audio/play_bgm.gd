@tool

class_name EVN_PlayBGM
extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}
@export var bus_effects: Array[AudioEffect] = []
@export var stream: AudioStream
@export var music_bus: MUSIC_BUS

@export_group("Volume and Pitch")
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

# -- tests
@export_group("Test Audio")
@export_tool_button("Play Test Audio") var play: Callable = play_test_audio
@export_tool_button("Stop Test Audio") var stop: Callable = stop_test_audio

func _execute() -> void:
	for fx in range(bus_effects.size()):
		Audio.remove_bus_effect("BGM", fx)

	for fx in range(bus_effects.size()):
		Audio.add_bus_effect("BGM", bus_effects[fx], fx)
		
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.		play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.	play_sound(stream, vol, pitch) 

func play_test_audio() -> void:	AudioService.play_test_audio_from("BGM", stream, vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
