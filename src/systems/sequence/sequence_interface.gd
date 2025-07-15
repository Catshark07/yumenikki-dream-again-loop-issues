@tool

class_name Sequence extends Event
var order: Array

@export var remove_invalid_events: bool = true
@export var halt_sequence: bool = false

func _ready() -> void:
	order = get_children()	

func _execute() -> void:
	if !_validate_event_order():
		printerr("SEQUENCE :: Sequence halted due to invalid events!") 
		return
	
	for event in order:
		if event != null and event is Event:
			(event as Event)._execute() 
			print(event)
			await event.finished


func _validate_event_order() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	
	for i in range(order.size()):
		var event = order[i]
		if !(event as Event)._validate():
			if halt_sequence: return false
			if remove_invalid_events: order.remove_at(i)
	
	return true
