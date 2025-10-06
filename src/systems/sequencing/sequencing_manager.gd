class_name SequencerManager
extends Game.GameSubClass

static var is_handling: bool = false
static var curr: Sequence

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	
	if is_handling and curr == _seq: 	# - cancel if sequence invoked is the same as current.
		cancel(curr)
		
	curr 		= _seq 
	is_handling = true
	_seq.execute()
	
static func cancel(_seq: Sequence) -> void: 
	
	if _seq == null: return
	print("cancelled:: %s" % _seq.name)
	
	is_handling = false
		
	_seq.time_elapsed = 0
	_seq.cancel()
	
static func _update(_delta: float) -> void:
	if 	curr != null and is_handling:
		curr.update(_delta)
	
static func step() -> void:
	if curr != null:
		if curr.has_next(): curr = curr.next
		else:				curr = null
