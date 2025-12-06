class_name ShakeCam
extends Event

@export var magnitude: float = 1
@export var speed: float = 1
@export var dur: float = 1

func _execute() -> void:
	CameraHolder.instance.shake(magnitude, speed, dur)

func _validate() -> bool: 
	return CameraHolder.instance != null
