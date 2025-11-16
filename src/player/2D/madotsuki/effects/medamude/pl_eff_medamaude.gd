extends PLEffect

const NORMAL_LOCATION_CHANCE: float = 0.7
const DAMNED_LOCATION_CHANCE: float = 0.3

var chance_value: 			float = 0:
	set(_val): chance_value = clampf(_val, 0, 1)
var rolled: 				bool = false

func _primary_action	(_pl: Player) -> void: 
	if  _pl.components.get_component_by_name(Player_YN.Components.ANIMATION) != null:
		_pl.force_change_state("action")
		_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(str(ACTION_PATH, "medamaude_teleport"))
		
func _secondary_action	(_pl: Player) -> void: 
	chance_value = randf_range(0, 1)
	if  _pl.components.get_component_by_name(Player_YN.Components.ANIMATION) != null:
		_pl.force_change_state("action")
		_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(str(ACTION_PATH, "medamaude_teleport"))
		
	
