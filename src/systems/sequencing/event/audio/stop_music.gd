class_name StopMusic
extends Event

@export var abrupt: bool = false

func _execute() -> void:
	await Music.fade_out()
