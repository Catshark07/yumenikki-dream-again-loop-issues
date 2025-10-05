class_name PLBehaviour
extends Resource

# ---- behaviour apply - unapply ----
func _apply		(_pl: Player) -> void: pass
func _unapply	(_pl: Player) -> void: pass

# ---- movement ----
func _idle		(_pl: Player, _delta: float) -> void: 
	if 	_pl.stamina < _pl.MAX_STAMINA:
		_pl.stamina += _delta * (_pl.stamina_regen)
func _walk		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.dir_input)
	if _pl.is_exhausted:  	_pl.speed_multiplier = Player.EXHAUST_MULTI
	else:					_pl.speed_multiplier = _pl.walk_multiplier
		
func _run		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.vel_input)
	_pl.speed_multiplier = _pl.sprint_multiplier
	
func _sneak		(_pl: Player, _delta: float) -> void: 	
	_pl.handle_direction(_pl.dir_input)
	_pl.speed_multiplier = _pl.sneak_multiplier

func _climb		(_pl: Player, _delta: float) -> void: pass

# ---- miscallenous ----
func _interact	(_pl: Player) -> void: 
	_pl.components.get_component_by_name("interaction_manager").handle_interaction()
