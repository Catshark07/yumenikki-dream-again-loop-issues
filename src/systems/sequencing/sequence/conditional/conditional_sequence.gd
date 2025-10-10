@tool

class_name ConditionalSequence
extends Sequence

@export var else_conditional: Sequence:
	set(else_seq):
		else_conditional = else_seq
		next = else_seq

func _execute() -> void:
	if _predicate(): 
		super()
	else:
		SequencerManager.cancel(self)

func _predicate() -> bool:
	return true
