class_name PLBehaviour
extends Resource

# ---- behaviour enter - exit ----
func _enter(_pl: Player) -> void: pass	
func _exit(_pl: Player) -> void: pass

# ---- behaviour apply - unapply ----
func _apply(_pl: Player) -> void: _pl.set_behaviour(self)
func _unapply(_pl: Player) -> void: _pl.revert_def_behaviour()

# ---- movement ----
func _idle(_pl: Player) -> void: 
	if _pl.desired_speed > 0:
		_pl.force_change_state("walk")
	
func _walk(_pl: Player) -> void: pass

		
func _run(_pl: Player) -> void:
	_pl.handle_direction(_pl.velocity.normalized())
		
func _sneak(_pl: Player) -> void:
	if _pl.desired_speed == 0: _pl.force_change_state("idle")
	if !Input.is_action_pressed("sneak"):  _pl.force_change_state("walk")

func _climb(_pl: Player) -> void: pass

# ---- miscallenous ----
func _interact(_pl: Player, _obj: Node) -> void: 
	_pl.components.get_component_by_name("interaction_manager").handle_interaction()
func _handle_primary_action(_pl: Player) -> void: pass
func _handle_secondary_action(_pl: Player) -> void: pass

# ---- update ----
func _physics_update(_pl: Player, _delta: float) -> void: pass
