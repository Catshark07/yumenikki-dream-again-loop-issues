class_name ConditionalSequence
extends Sequence

@export var else_conditional: Sequence

func _execute() -> void:
	if _predicate(): 
		super()
	else:
		SequencerManager.cancel(self)
		SequencerManager.invoke(else_conditional)

func _predicate() -> bool:
	return true
