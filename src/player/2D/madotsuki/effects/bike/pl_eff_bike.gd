extends PLEffect

func _apply(_pl: Player) -> void: 
	_pl.components.get_component_by_name("sprite_manager").set_dynamic_rot_multi(0.45)
	_pl.stamina += Player.MAX_STAMINA * .65
func _unapply(_pl: Player) -> void:
	_pl.components.get_component_by_name("sprite_manager").set_dynamic_rot_multi(
		SentientAnimator.DEFAULT_DYNAMIC_ROT_MULTI)
