extends Event

@export var event: Event

func _execute() -> void:
	if event is Event and !(event is Sequence): event.execute()
	elif event is Sequence:						SequencerManager.invoke(event)
	
func _validate() -> bool:
	return event != null and event is Event
