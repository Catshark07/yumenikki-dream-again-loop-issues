class_name InvokeEventID
extends Event

@export var event_id: String
@export var params: Array[Variant]

func _execute() -> void: 
	EventManager.invoke_event(event_id, params)
	super()
