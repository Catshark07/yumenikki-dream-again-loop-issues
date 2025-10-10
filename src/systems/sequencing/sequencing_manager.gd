class_name SequencerManager
extends Game.GameSubClass

static var curr: Sequence

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	
	await cancel(curr)
		
	curr 		= _seq 
	curr.execute()
	
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	if _seq == curr: curr = null
	
	_seq.cancel()
	await _seq.canceled
	
