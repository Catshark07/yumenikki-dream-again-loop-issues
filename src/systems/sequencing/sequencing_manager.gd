class_name SequencerManager
extends Game.GameSubClass

static var is_handling: bool = false
static var curr: Sequence

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	
	if is_handling and curr == _seq: 	# - cancel if sequence invoked is the same as current.
		cancel(curr)
		
	is_handling = true
	curr 		= _seq 
	curr.execute()
	
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	if _seq == curr: curr = null
	
	is_handling = false
	_seq.cancel()
	
static func _update(_delta: float) -> void:
	if 	curr != null and is_handling:
		curr.update(_delta)
