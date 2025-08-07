class_name List
extends RefCounted

const EMPTY = null

## Array holding the stack content.
var array: Array = []
var accepts_null: bool = false

var iter_idx
var iter_size

func _init(_size: int = 0) -> void: array.resize(_size)
		
## Gets the stack size.
func get_size() -> void: return array.size()

## Returns the top element without removing it.
func get_front() -> Variant: 
	return array.front()
func get_back() -> Variant: 
	return array.back()
func get_at_idx(_idx: int) -> Variant: 
	if _idx <= array.size() - 1: return array[_idx]
	return null 

func pop_at_idx(_idx: int) -> Variant:
	if _idx <= array.size() - 1: return array.pop_at(_idx)
	return null

## Returns and removes the top element of the list.
func add_to_back(_element: Variant) -> void: 
	if _element == null and accepts_null: array.append(_element)
	elif _element != null:  array.append(_element)
func add_to_front(_element: Variant) -> void: pass

func find(_element: Variant) -> int:
	return array.find(_element)
