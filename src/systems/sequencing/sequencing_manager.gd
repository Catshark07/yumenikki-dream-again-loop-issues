class_name SequencerManager
extends Game.GameSubClass

static var curr_sequence: Sequence
static var sequence_stack: Stack

static var is_handling: bool = false

static func _setup() -> void:
	sequence_stack = Stack.new()

static func invoke(_seq: Sequence) -> void: 
	if _seq == null: return
	print("SequenceManger :: Current Sequence Handled - ", _seq)

	is_handling = true
	queue_sequence(_seq)
	_seq.finished.connect(
		func(): 
			is_handling = false
			enqueue_sequence(), 
		ConnectFlags.CONNECT_ONE_SHOT)
	_seq.execute()
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	
	_seq.bail_requested = true
	_seq.time_elapsed = 0
	is_handling = false

static func queue_sequence(_seq: Sequence) -> void: sequence_stack.push(_seq)
static func enqueue_sequence() -> Sequence: 		return sequence_stack.pop()

static func _update(_delta: float, _seq: Sequence = null) -> void:
	if _seq == null: return
	if is_handling:
		_seq.update(_delta)
