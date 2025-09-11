class_name ConditionalSequence
extends Sequence

@export var else_conditional: Sequence

func _execute() -> void:
	if _predicate(): 
		super()
		return
	elif else_conditional != null: SequencerManager.invoke(else_conditional)

func _predicate() -> bool:
	return true
