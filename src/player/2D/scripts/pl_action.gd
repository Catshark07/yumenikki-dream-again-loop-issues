class_name PLAction
extends Resource

# ---- initial
func _enter(_pl: Player) -> void: pass
func _exit(_pl: Player) -> void: pass

func _perform(_pl: Player) -> bool: return true
func _cancel(_pl: Player) -> void: pass

# ---- essentials
func _update(_pl: Player, _delta: float) -> void: pass
func _physics_update(_pl: Player, _delta: float) -> void: pass
func _input(_pl: Player, _input: InputEvent) -> void: pass
