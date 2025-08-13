extends PLAction

@export var sound: AudioStream

func _perform(_pl: Player) -> bool: 
	AudioService.play_sound(sound)
	return true
