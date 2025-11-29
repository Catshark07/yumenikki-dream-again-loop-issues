class_name SequencerManager
extends Game.GameSubClass

static var curr: Sequence

static func invoke(_seq: Sequence, _force_continue: bool = false) -> void:
	if _seq == null or !(_seq is Sequence): return
	
	if 	_seq.async:
		_seq.execute()
		return
		
	if curr != null:
		await cancel()
		if curr == _seq:
			curr = null
			if !_force_continue: return
	
	curr 		= _seq 
	curr.finished.connect(func(): 
		curr = null, CONNECT_ONE_SHOT)
		
	curr.execute()
static func cancel() -> void: 
	if curr == null or !(curr is Sequence): return
	curr.cancel()
	await curr.cancelled
	
static func create_sequence(_name: String, _skip_invalid: bool = true, _wait_finish: bool = true) -> Sequence: 
	var seq = Sequence.new()
	seq.name 					= _name 
	seq.skip_invalid_events 	= _skip_invalid
	seq.wait_til_finished 		= _wait_finish
	
	Game.add_child(seq)
	Utils.connect_to_signal(seq.queue_free, seq.finished, ConnectFlags.CONNECT_ONE_SHOT)
	
	return seq 
	
static func add_event(_seq: Sequence, _event: Event, _name: String, _wait_til_finished: bool = true) -> void:
	_event.name = _name
	_event.wait_til_finished = _wait_til_finished
	_seq.add_child(_event)
