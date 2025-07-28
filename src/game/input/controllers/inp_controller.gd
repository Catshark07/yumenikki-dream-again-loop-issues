class_name InputController
extends RefCounted

var dir_input: Vector2i

func _setup() -> void: pass
func _controller_input(_event: InputEvent) -> void: pass
func _update(_delta: float) -> void: pass

# - optional helper.
func is_action_held(_event: InputEvent, _action: String) -> bool: 
	return _event.is_action(_action) and !_event.is_action_released(_action)

class Scheme:
	extends RefCounted
	
	# command_dict should look like this: <COMMAND : ACTION_ID>
	
	var keybind: InputManager.Keybind
	var command_dict: Dictionary[Command, String]
	
	func _init(_binds: InputManager.Keybind) -> void: keybind = _binds
		
	func handle_command(_action: String) -> void:
		if _action.is_empty(): return
		
		if Input.is_action_pressed(_action):
			if  command_dict.find_key(_action) != null:
				command_dict.find_key(_action)._execute()
