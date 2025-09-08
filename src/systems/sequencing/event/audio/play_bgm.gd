extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}

@export var music_bus: MUSIC_BUS
@export var stream: AudioStream
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.play_sound(stream, vol, pitch) 
