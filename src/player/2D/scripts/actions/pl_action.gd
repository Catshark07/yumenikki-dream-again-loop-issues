class_name PLAction
extends Resource

var animation_path := ""

# - called when the action perform is requested..
func _perform(_pl: Player) -> bool: return true

# - called when the action is entered or exited respectively.
func _action_enter(_pl: Player) -> void: pass
func _action_exit(_pl: Player) -> void: pass

# - manager
func _action_input(_pl: Player, _input: InputEvent) -> void: pass
func _action_update(_pl: Player, _delta: float) -> void: pass
func _action_physics_update(_pl: Player, _delta: float) -> void: pass
