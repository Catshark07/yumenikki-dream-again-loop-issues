class_name SequencerManager
extends Game.GameSubClass

static var curr: Object

static func invoke(_seq: Object, _force_continue: bool = false) -> void:
	if _seq == null: return

	if curr != null:
		await cancel()
		if curr == _seq:
			curr = null
			if !_force_continue: return
	
	if _seq is Sequence:
		curr 		= _seq 
		curr.finished.connect(func(): 
			curr = null, CONNECT_ONE_SHOT)
		
		curr.execute()
		
static func cancel() -> void: 
	if curr == null: return
	
	if curr is Sequence:
		
		curr.cancel()
		await curr.cancelled
	
static func create_event() 		-> EventObject: 	return
static func create_sequence() 	-> SequenceObject: 	return
	
# - event objects.
	
@abstract
class EventObject: 
	extends Object

	signal finished
	signal cancelled

	func _init() -> void: pass
	func pass_args(_args_dict: Dictionary) -> void: 
		for i in get_property_list():
			if i["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
				set_indexed(i["name"], _args_dict.get(i["name"]))
				
		print("success")

	@abstract
	func _execute() -> 	void
	@abstract
	func _end() -> 		void
	@abstract
	func _cancel() -> 	void

	@abstract
	func _validate() -> bool

	
class SequenceObject:
	extends EventObject
	
	var events: Array[EventObject]
	var front: 	EventObject
	var back: 	EventObject
	
	signal success
	signal fail
	
	var skip_invalid_events: bool = true
	var bail_requested:		 bool = false

	func _init(_skip_invalid_events: bool, ..._events) -> void: 
		skip_invalid_events = _skip_invalid_events
		
		for i in _events:
			events.append(_events)
		
		if _events.size() == 0: return
		front = _events[0]
		back = _events[_events.size()]
		
	func _execute() -> 	void: 
		if !_validate():
			printerr("SEQUENCE %s :: Sequence halted due to invalid events!" % (self.name)) 
			return
		
		# - we iterate thru the events..
		for i in range(events.size()):
			# - make sure that the child is of type Event.
			var curr = events[i]
			
			if 	curr is EventObject and curr != null:
				curr.execute() 
				curr.end()
				
			else: continue
			
			if 	bail_requested: 
				break	
			
		_end()
			
	func _end() -> 		void: bail_requested = false
	func _cancel() -> 	void: bail_requested = true

	func _validate() -> bool: 
		var revised_events_arr: Array[EventObject] = []
		
		for event in events:
			if event.skip or event == null: continue
			if !event._validate():
				# - if event is invalid...
				if skip_invalid_events: continue
				else:
					fail.emit() 
					return false
		
			revised_events_arr.append(event)
		
		success.emit()
		events = revised_events_arr
		return true

	func push(_event: EventObject) -> void: events.append(_event)
	func pop() -> EventObject: return 		events.pop_back()
