class_name PlaySound
extends Event

@export var sound: AudioStream = null
@export var volume: float = 1
@export var pitch: float = 1


func _execute() -> void:
	if !wait_til_finished: super()
	await AudioService.play_sound(sound, volume, pitch)
	if wait_til_finished: super()

func _validate() -> bool:
	if sound == null: 
		printerr("EVENT - PLAYSOUND :: Sound is null!")
		return false
	return true
