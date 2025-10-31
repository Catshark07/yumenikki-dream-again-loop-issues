class_name EVO_PlaySound
extends SequencerManager.EventObject

var sound: AudioStream = null
var vol: float = 1:
	set(_vol): vol = clampf(_vol, 0, 1)
var pitch: float = 1:
	set(_pit): vol = clampf(_pit, 0.1, 2)

func _init(_sound: AudioStream, _vol: float = 1, _pitch: float = 1) -> void:
	sound 	= _sound
	vol 	= _vol
	pitch 	= _pitch
	super()

func _execute() -> void:
	await AudioService.play_sound(sound, vol, pitch)

func _validate() -> bool:
	if sound == null: 
		printerr("EVO - PLAYSOUND :: Sound is null!")
		return false
	return true

func _end() -> 		void: pass
func _cancel() -> 	void: AudioService.stop()
