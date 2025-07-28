class_name Command
extends RefCounted

var input_args: Array = []

func execute() -> void:
	_execute(input_args)
func _execute(_args = []) -> void: pass
func _bind(_args = []) -> Command: 
	input_args = _args
	return self
