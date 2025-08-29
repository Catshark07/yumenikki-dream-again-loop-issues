class_name PlaySound
extends Event

@export var sound: AudioStream = null
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

func _execute() -> void:
	await AudioService.play_sound(sound, vol, pitch)

func _validate() -> bool:
	if sound == null: 
		printerr("EVENT - PLAYSOUND :: Sound is null!")
		return false
	return true
