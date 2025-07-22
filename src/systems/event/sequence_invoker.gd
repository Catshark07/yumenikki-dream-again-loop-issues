class_name SequenceInvoker
extends Node

@export var sequence_data: SequenceData

func _ready() -> void: _execute()
func _execute() -> void: SequenceGraphEditor.execute()
