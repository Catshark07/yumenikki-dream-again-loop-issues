@tool

class_name Sequence extends Event

var time_elapsed: float = 0 

var order: Array
var marked_for_skip: PackedInt32Array

var priority: int = 0
var bail_requested: bool = false

@export_group("Sequence Flags.")
@export var skip_invalid_events: bool = false
@export var is_asynchronous: bool = false
@export var print_debug: bool = false

func _ready() -> void:
	# - get events.
	order = get_children()	

func _execute() -> void:
	# - if bail is requested, we don't execute this sequence.
	if bail_requested: 
		return
	
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
			if print_debug: print("CURR EVENT HANDLED::: ", event)
			
			event.execute() 
			if event.wait_til_finished: await event.finished
			event.end()
func _cancel() -> void:
	bail_requested = true	
			 
func _validate_event_order() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	for i in range(order.size()):
		var event = order[i] # - current event.
		if event == null or !(event as Event)._validate():
			# - if event is invalid...
			if skip_invalid_events: marked_for_skip.append(i) # - we mark invalid events to be skipped.
			else: return false # - we halt the sequence if the sequence if we won't skip any invalid events.
			
	return true

func update(_delta: float) -> void: 
	time_elapsed += _delta
