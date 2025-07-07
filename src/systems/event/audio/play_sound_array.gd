class_name PlaySoundArray
extends Event

@export var sound_arr: Array[AudioStream] = []
@export var volume: float = 1
@export var pitch: float = 1

func _execute() -> void:
	if !wait_til_finished: super()
	var sound = sound_arr.pick_random() 
	await AudioService.play_sound(sound_arr.pick_random(), volume, pitch)
	if wait_til_finished: super()
