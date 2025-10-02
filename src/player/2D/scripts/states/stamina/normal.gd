extends SBState

func _state_enter() -> void:
	sentient.speed_multiplier = Player.WALK_MULTI
	
func _state_physics_update(_delta: float) -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_MENTAL).bpm = (
		sentient.components.get_component_by_name(Player_YN.COMP_MENTAL).calculate_bpm())
		
		
