extends Event

@export var target: CanvasItem
@export var switch_dur: float = .5

func _execute() -> void:
	CameraHolder.instance.set_target(target, switch_dur)

func _validate() -> bool:
	return target != null and CameraHolder.instance != null
