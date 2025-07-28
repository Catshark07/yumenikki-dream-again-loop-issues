class_name Stack
extends RefCounted

const EMPTY = null
signal popped(_element: Variant)

## Array holding the stack content.
var array: Array = []
var accepts_null: bool = false

func _init(_size: int = 0) -> void: array.resize(_size)

## Gets the stack size.
func get_size() -> void: return array.size()

## Returns the top element without removing it.
func peek() -> Variant:
	if array.is_empty(): return EMPTY
	return array[array.size() - 1]

## Returns and removes the top element of the stack.
func pop() -> Variant: 
	if array.is_empty(): return EMPTY
	popped.emit(array.back())
	return array.pop_back()

## Pushes a new element onto the stack, essentially becoming the new top.
func push(_element: Variant) -> void: 
	if accepts_null and _element == null: array.append(_element)
	elif _element != null: array.append(_element)
