class_name SequencerManager
extends Node

var curr_sequence: Sequence
var active_sequences: Array[Sequence]

var is_handling: bool = false

func invoke(_seq: Sequence) -> void: 
	if is_handling: return
	is_handling = true
	_seq.execute()
func cancel(_seq: Sequence) -> void: pass

func handle(_seq: Sequence, _delta: float) -> void:
	_seq.update(_delta)
