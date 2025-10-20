class_name PLAction
extends Resource

# -- virtuals.
func _perform		(_pl: Player) -> void: pass
func _cancel		(_pl: Player) -> void: pass
func _force_cancel	(_pl: Player) -> void: pass

# - process, phys process and input. 
func _action_input			(_pl: Player, _input: InputEvent) -> void: pass
func _action_update			(_pl: Player, _delta: float) -> void: pass
func _action_physics_update	(_pl: Player, _delta: float) -> void: pass
