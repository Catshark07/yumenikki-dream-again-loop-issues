class_name InputController
extends RefCounted

var dir_input: Vector2i

func _setup() -> void: pass
func _handled_input(_event: InputEvent) -> void: pass
func _unhandled_input(_event: InputEvent) -> void: pass
func _update(_delta: float) -> void: pass

# - optional helper.
func is_action_held(_event: InputEvent, _action: String) -> bool: 
	return _event.is_action(_action) and !_event.is_action_released(_action)
