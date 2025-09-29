@tool

class_name Sequence extends Event

var time_elapsed: float = 0 

var order: Array
var marked_invalid: PackedInt32Array

var priority: int = 0
var bail_requested: bool = false

@export_tool_button("Re-initialize Sequence Order") var reinitialize := initialize

@export_group("Sequence Flags.")
@export var skip_invalid_events	: bool = false
@export var async				: bool = false
@export_storage var initialized	: bool = false

@export_group("Front and Back.")
@export var front: Event
@export var back: Event

signal success
signal fail

func _ready() -> void:
	if !initialized:
		initialized = true
		initialize()
		
func initialize() -> void:
	order = get_children()	
	if order.is_empty(): return
	
	front = order[0]
	back = order[order.size() - 1]
		
	for i: int in range(order.size()):
		var j := i + 1
		var _curr: 	Event = order[i]
		var _next: 	Event  = null
		
		if j < order.size():
			_next = order[j]
			_curr.next = _next
			_next.prev = _curr

func _execute() -> void:
	# - if bail is requested, we don't execute this sequence.
	if bail_requested: 
		return
	
	# - if the sequence is not valid, we halt and not run it.
	if !validate_event_order():
		printerr("SEQUENCE %s :: Sequence halted due to invalid events!" % (self.name)) 
		return
	
	var event: Event = null
	# - we iterate thru the events..
	if 	front != null:
		event = front
		
		while(event.has_next()):
			if event.get_instance_id() in marked_invalid or event.skip: 
				continue # - we skip any events marked for skip / as invalid.
				
			print(event)
			event.execute()
			if event.wait_til_finished: await event.finished
			event.end()

			event = event.next
			
			if bail_requested: 
				bail_requested = false
				return

func _cancel() -> void:
	bail_requested = true	
			 
func validate_event_order() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	for i: Event in order:
		if i.skip: continue 
		if i == null or !i._validate():
			# - if event is invalid...
			
			if skip_invalid_events: marked_invalid.append(i.get_instance_id()) # - we mark invalid events to be skipped.
			else:
				printerr("SEQUENCE %s :: Sequence halted due to invalid event: %s!" % [self.name, i.name]) 
				fail.emit()
				return false # - we halt the sequence if the sequence if we won't skip any invalid events.
		
	success.emit()	
	return true

func update(_delta: float) -> void: 
	time_elapsed += _delta
