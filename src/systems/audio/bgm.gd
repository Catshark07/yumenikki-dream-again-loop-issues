class_name BGM extends Component

enum MUSIC_BUS {MUSIC, AMBIENCE}

@export var music_bus: MUSIC_BUS

@export_group("Music Properties")
	
@export var stream: AudioStream
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

## -------- AUDIO CLIP CONTROL (E.G LOOP or smth) -------- ##	
func _setup() -> void:	
		play_music()

func play_music() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 
			Music.fade_in()
			Music.play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: 
			Ambience.fade_in()
			Ambience.play_sound(stream, vol, pitch) 

## -------- AUDIO CONTROL (E.G AUDIO FADE) -------- ##
