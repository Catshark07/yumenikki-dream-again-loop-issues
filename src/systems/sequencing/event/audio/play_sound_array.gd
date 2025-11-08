@tool

class_name PlaySoundArray
extends Event

@export var sound_arr: Array[AudioStream] = []
@export var volume: float = 1
@export var pitch: float = 1

# -- test
@export_tool_button("Play Test Audio") var play: Callable = play_test_audio
@export_tool_button("Stop Test Audio") var stop: Callable = stop_test_audio

func _execute() -> void:
	var sound = sound_arr.pick_random() 
	await AudioService.play_sound(sound_arr.pick_random(), volume, pitch)


func play_test_audio() -> void:	AudioService.play_sound(sound_arr.pick_random(), volume, pitch)
func stop_test_audio() -> void: AudioService.stop()
