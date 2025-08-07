extends PLBehaviour

func _enter(_pl: Player) -> void: 
	(_pl as Player_YN).components.get_component_by_name("sprite_handler").set_dynamic_rot_multi(0.45)
	(_pl as Player_YN).stamina = Player.MAX_STAMINA
func _exit(_pl: Player) -> void:
	(_pl as Player_YN).components.get_component_by_name("sprite_handler").set_dynamic_rot_multi(
		SentientAnimator.DEFAULT_DYNAMIC_ROT_MULTI)
