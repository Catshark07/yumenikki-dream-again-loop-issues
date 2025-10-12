class_name SequencerManager
extends Game.GameSubClass

static var curr: Sequence

static func invoke(_seq: Sequence) -> void:
	if _seq == null: return
	
	await cancel(curr)
	_seq.finished.connect(func(): curr = null, CONNECT_ONE_SHOT)
	_seq.execute()
		
	curr 		= _seq 
	
static func cancel(_seq: Sequence) -> void: 
	if _seq == null: return
	if _seq == curr: curr = null
	
	_seq.cancel()
	await _seq.canceled
	
