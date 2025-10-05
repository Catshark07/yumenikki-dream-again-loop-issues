@tool

class_name Sequence extends Event

var time_elapsed: float = 0 
var priority: int = 0

@export var order: Array[Node]
var marked_invalid: PackedInt32Array
var bail_requested: 				bool = false

@export_tool_button("Re-initialize Sequence Order") var reinitialize: Callable = initialize
@export_group("Sequence Flags.")

@export var skip_invalid_events: 	bool = false
@export var async: 					bool = false
@export var initialized: 			bool = false

@export var front: Event
@export var back: Event

# - signals
signal success
signal fail

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
			if !_curr.custom_linked_pointers: _curr.next = _next
			if !_next.custom_linked_pointers: _next.prev = _curr
func _ready() -> void:
	if !initialized: 
		initialized = true
		initialize()

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
			
			print(event.skip)
			if e in marked_invalid or event.skip : continue # - we skip any events marked for skip / as invalid.
			
			event.execute() 
			if event.wait_til_finished: await event.finished
			event.end()
			
			if bail_requested: 
				bail_requested = false
				return
func _cancel() -> void:
	bail_requested = true	
			 
func _validate_event_order() -> bool:
	# - we are going to validate that every single event is happy and satisifed:
	# checking for any missing dependencies, has the corect properties, etc.
	for i in range(order.size()):
		var event: Event = order[i] # - current event.
		if event.skip: continue 
		if event == null or !event._validate():
			# - if event is invalid...
			if skip_invalid_events: marked_invalid.append(i) # - we mark invalid events to be skipped.
			else:
				fail.emit()
				return false # - we halt the sequence if the sequence if we won't skip any invalid events.
		
	success.emit()	
	return true

func update(_delta: float) -> void: 
	time_elapsed += _delta
