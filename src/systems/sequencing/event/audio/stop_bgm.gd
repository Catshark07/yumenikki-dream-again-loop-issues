extends Event

enum MUSIC_BUS {MUSIC, AMBIENCE}
@export var music_bus: MUSIC_BUS

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.		stop()
		MUSIC_BUS.AMBIENCE: Ambience.	stop()
