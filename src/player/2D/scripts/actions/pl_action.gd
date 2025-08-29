class_name PLAction
extends Resource

var can_exit: bool = true

func _perform(_pl: Player) -> void: pass
func _cancel(_pl: Player) -> void: pass

# - called when the action is entered or exited respectively.
func _action_on_enter(_pl: Player) -> void: pass
func _action_on_exit(_pl: Player) -> void: pass
func _action_on_request_exit(_pl: Player) -> void: pass

# - process, phys process and input. 
func _action_input(_pl: Player, _input: InputEvent) -> void: pass
func _action_update(_pl: Player, _delta: float) -> void: pass
func _action_physics_update(_pl: Player, _delta: float) -> void: pass

func request_exit(_pl: Player) -> void:
	if !can_exit: return
	_action_on_request_exit(_pl)
	
