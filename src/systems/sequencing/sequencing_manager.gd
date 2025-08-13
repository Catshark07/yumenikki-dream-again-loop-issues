class_name SequencerManager
extends Game.GameSubClass

static var curr_sequence: Sequence
static var sequence_stack: Stack

static var is_handling: bool = false

static func _setup() -> void:
	sequence_stack = Stack.new()

static func invoke(_seq: Sequence) -> void: 
	if _seq == null: return
	
	if is_handling: return
	is_handling = true
	_seq.execute()
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	
	_seq.bail_requested = true
	_seq.time_elapsed = 0
	is_handling = false

static func queue_sequence() -> void: pass
static func enqueue_sequence() -> void: pass

static func _update(_delta: float, _seq: Sequence = null) -> void:
	if _seq == null: return
	if is_handling:
		_seq.update(_delta)
