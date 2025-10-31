class_name EVO_PlayBGM
extends SequencerManager.EventObject

enum MUSIC_BUS {MUSIC, AMBIENCE}

var music_bus: MUSIC_BUS = MUSIC_BUS.MUSIC
var stream: AudioStream
var vol: float = 1
var pitch: float = 1

func _init(
	_stream: AudioStream, 
	_vol: 	float = 1, 
	_pitch: float = 1, 
	_bus: MUSIC_BUS = MUSIC_BUS.MUSIC) -> void:
		stream 		= _stream
		vol 		= _vol
		pitch 		= _pitch
		music_bus 	= _bus
		
		super()

func _execute() -> void:
	match music_bus:
		MUSIC_BUS.MUSIC: 	Music.play_sound(stream, vol, pitch)
		MUSIC_BUS.AMBIENCE: Ambience.play_sound(stream, vol, pitch) 

func _end() -> 		void: pass
func _validate() -> bool: return true
func _cancel() -> void: pass
