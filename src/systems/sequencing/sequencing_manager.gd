class_name SequencerManager
extends Game.GameSubClass

static var is_handling: bool = false
static var curr: Sequence

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	is_handling = true
	
	if curr == _seq: 	# - cancel if sequence invoked is the same as current.
		cancel(curr)
		
	curr 		= _seq 
	curr.execute()
	
static func cancel(_seq: Sequence) -> void: 
	
	if _seq == null: return
	print("cancelled:: %s" % _seq.name)
	
	is_handling = false
		
	_seq.time_elapsed = 0
	_seq.cancel()
	
static func _update(_delta: float) -> void:
	if 	curr != null and is_handling:
		print(curr)
		curr.update(_delta)
	
