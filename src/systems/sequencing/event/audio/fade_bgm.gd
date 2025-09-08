extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}
@export var music_bus: MUSIC_BUS
@export var abrupt: bool = false

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	
			if !abrupt: await Music.fade_out()
			Music.stop()
		MUSIC_BUS.AMBIENCE: 
			if !abrupt: await Ambience.fade_out()
			Ambience.stop()
