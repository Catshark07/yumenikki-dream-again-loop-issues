@tool

class_name Sequence extends Event

var time_elapsed: float = 0 

var order: Array
var marked_for_skip: PackedInt32Array

var priority: int = 0
var bail_requested: bool = false

@export var skip_invalid_events: bool = true
@export var halt_invalid_sequence: bool = false

func _ready() -> void:
	# - get events.
	order = get_children()	
func _execute() -> void:
	# - if the sequence is not valid, we halt and not run it.
	if !_validate_event_order():
		printerr("SEQUENCE %s :: Sequence halted due to invalid events!" % (self.name)) 
		return
	
	# - we iterate thru the events..
	for e in range(order.size()):
		# - make sure that the child is of type Event.
		var event = order[e]
		if event != null and event is Event:
			
			if e in marked_for_skip: continue # - we skip any events marked for skip / as invalid.
			event.execute() 
			await event.finished
			event.end() 
func _validate_event_order() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	
	for i in range(order.size()):
		var event = order[i] # - current event.
		if event == null or !(event as Event)._validate():
			# - if event is invalid...
			if halt_invalid_sequence: 
				return false # - we halt the sequence if the sequence is marked for halt.
			if skip_invalid_events: marked_for_skip.append(i) # - we mark invalid events to be skipped.
			
	return true


func update(_delta: float) -> void: 
	time_elapsed += _delta
