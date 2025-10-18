extends PLEffect

@export var primary_action: PLAction
@export var secondary_action: PLAction

func _primary_action	(_pl: Player) -> void: 
	_pl.components.get_component_by_name(_pl.COMP_ACTION).perform_action(primary_action, _pl)
func _secondary_action	(_pl: Player) -> void: 
	_pl.components.get_component_by_name(_pl.COMP_ACTION).perform_action(secondary_action, _pl)
	
