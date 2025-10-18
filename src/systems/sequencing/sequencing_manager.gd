class_name SequencerManager
extends Game.GameSubClass

static var curr: Object

static func invoke(_seq: Object) -> void:
	if _seq == null: return

	if curr != null:
		await cancel()
		if curr == _seq:
			curr = null
			return
	
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
	
	signal success
	signal fail
	
	var skip_invalid_events: bool = true
	var events: Array[EventObject]

	func _execute() -> 	void: 
		for event in events: pass
			
	func _end() -> 		void: pass
	func _cancel() -> 	void: pass

	func _validate() -> bool: 
		var revised_events_arr: Array[EventObject] = []
		
		for event in events:
			if event.skip or event == null: continue
			if !event._validate():
				# - if event is invalid...
				if skip_invalid_events: continue
				else: return false
		
			revised_events_arr.append(event)
		
		events = revised_events_arr
		return true

	func push(_event: EventObject) -> void: events.append(_event)
	func pop() -> EventObject: return events.pop_back()
