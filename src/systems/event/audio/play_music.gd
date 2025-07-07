extends Event

@export var stream: AudioStream
@export_range(0, 1, .1) var vol: float = 1
@export_range(0.1 , 2, .01) var pitch: float = 1

func _execute() -> void:
	Music.play_sound(stream)
	finished.emit()
