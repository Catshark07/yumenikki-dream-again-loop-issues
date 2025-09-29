extends PLEffect

const NORMAL_LOCATION_CHANCE: float = 0.7
const DAMNED_LOCATION_CHANCE: float = 0.3

var chance_value			: float = 0
var rolled: bool = false

#func _use(_pl: Player) -> void: 
	#super(_pl)
	
