class_name SequencerManager
extends Game.GameSubClass

static var curr_sequence: Sequence
static var sequence_stack: Stack

static var is_handling: bool = false

static func _setup() -> void:
	sequence_stack = Stack.new()

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	if curr_sequence == _seq: 
		cancel(_seq)
		return

	curr_sequence = _seq 
	
	print("SequenceManger :: Current Sequence Handled - ", _seq)

	is_handling = true
	enqueue_sequence(_seq)
	_seq.finished.connect(__handle_dequeue, ConnectFlags.CONNECT_ONE_SHOT)
	_seq.execute()
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	print("SequenceManger :: Cancelling - ", _seq)
	
	is_handling = false
		
	_seq.time_elapsed = 0
	_seq.cancel()
	_seq.canceled.connect(func(): _seq.bail_requested = false, CONNECT_ONE_SHOT)

static func enqueue_sequence(_seq: Sequence) -> void: 
	sequence_stack.push(_seq)
	curr_sequence = _seq
static func dequeue_sequence() -> Sequence: 		
	var popped_seq = sequence_stack.pop()
	curr_sequence = sequence_stack.peek()
	return popped_seq

static func __handle_dequeue() -> void:
	is_handling = false
	dequeue_sequence()

static func _update(_delta: float, _seq: Sequence = null) -> void:
	if _seq == null: return
	if is_handling:
		_seq.update(_delta)
