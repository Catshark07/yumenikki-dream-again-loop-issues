@tool

class_name EVN_PlayBGM
extends Event

@onready var scene_change_listener := EventListener.new(self, "SCENE_CHANGE_REQUEST")

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

func _ready() -> void:
	scene_change_listener.do_on_notify(
		func():
			__reset_bus_effects
			scene_change_listener = null, 
		"SCENE_CHANGE_REQUEST")

func __reset_bus_effects() -> void:
	for fx in Audio.get_bus_effect_count("BGM"):
		Audio.remove_bus_effect("BGM", fx)

func _execute() -> void:
	__reset_bus_effects()

	for fx in range(bus_effects.size()):
		Audio.add_bus_effect("BGM", bus_effects[fx], fx)
		
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.		play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.	play_sound(stream, vol, pitch) 

func play_test_audio() -> void:	AudioService.play_test_audio_from("BGM", stream, vol, pitch)
func stop_test_audio() -> void: AudioService.stop()
