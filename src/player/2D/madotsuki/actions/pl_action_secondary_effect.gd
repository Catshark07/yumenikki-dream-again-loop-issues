extends PLAction

func _perform		(_pl: Player) -> void:
	if _pl.components.get_component_by_name(Player_YN.COMP_EQUIP).effect_data == null: return
	_pl.components.get_component_by_name(Player_YN.COMP_EQUIP).effect_data._secondary_action(_pl)
