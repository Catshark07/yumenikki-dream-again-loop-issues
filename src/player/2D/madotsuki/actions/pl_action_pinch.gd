extends PLAction

func _use(_pl: Player) -> void:
	_pl.deequip_effect()
	_pl.components.get_component_by_name("animation_manager")
