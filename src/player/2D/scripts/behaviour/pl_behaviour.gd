class_name PLBehaviour
extends Resource

@export var auto_run: bool = false

# ---- behaviour apply - unapply ----
func _apply(_pl: Player) -> void: pass
func _unapply(_pl: Player) -> void: pass

# ---- movement ----
func _idle(_pl: Player) -> void:  pass
func _walk(_pl: Player) -> void:  _pl.handle_direction(_pl.dir_input)
func _run(_pl: Player) -> void:   _pl.handle_direction(_pl.vel_input)
		
func _sneak(_pl: Player) -> void: _pl.handle_direction(_pl.dir_input)

func _climb(_pl: Player) -> void: pass

# ---- miscallenous ----
func _interact(_pl: Player, _obj: Node) -> void: 
	_pl.components.get_component_by_name("interaction_manager").handle_interaction()
func _handle_primary_action(_pl: Player) -> void: pass
func _handle_secondary_action(_pl: Player) -> void: pass

# ---- update ----
func _physics_update(_pl: Player, _delta: float) -> void: pass
