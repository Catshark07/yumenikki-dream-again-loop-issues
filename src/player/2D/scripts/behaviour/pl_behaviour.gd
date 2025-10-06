class_name PLBehaviour
extends Resource

# ---- behaviour apply - unapply ----
func _apply		(_pl: Player) -> void: pass
func _unapply	(_pl: Player) -> void: pass

# ---- movement ----
func _idle		(_pl: Player, _delta: float) -> void: 
	if 	_pl.stamina < _pl.MAX_STAMINA:
		_pl.stamina += _delta * (_pl.get_values().stamina_regen)
func _walk		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.dir_input)
	_pl.noise_multi 		= _pl.get_values().walk_noise_multi
	
	if _pl.is_exhausted:  	_pl.speed_multiplier = Player.EXHAUST_MULTI
	else:					_pl.speed_multiplier = _pl.get_values().walk_multi
		
func _run		(_pl: Player, _delta: float) -> void:  
	_pl.handle_direction(_pl.vel_input)
	_pl.noise_multi 		= _pl.get_values().sprint_noise_multi
	_pl.speed_multiplier 	= _pl.get_values().sprint_multi

	
func _sneak		(_pl: Player, _delta: float) -> void: 	
	_pl.handle_direction(_pl.dir_input)
	_pl.noise_multi 		= _pl.get_values().sneak_noise_multi
	
	_pl.speed_multiplier = _pl.get_values().sneak_multi

func _climb		(_pl: Player, _delta: float) -> void: pass

# ---- miscallenous ----
func _interact	(_pl: Player) -> void: 
	_pl.components.get_component_by_name("interaction_manager").handle_interaction()
