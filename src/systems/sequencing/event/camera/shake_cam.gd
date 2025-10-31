class_name ShakeCam
extends Event

@export var magnitude: float = 1
@export var speed: float = 1
@export var dur: float = 1

func _execute() -> void:
	CameraHolder.instance.shake(magnitude, speed, dur)
	super()

func _validate() -> bool: 
	if CameraHolder.instance == null:
		return false
	return true
