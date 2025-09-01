extends Event

@export var event: Event

func _execute() -> void:
	event.execute()
func _validate() -> bool:
	return event != null
