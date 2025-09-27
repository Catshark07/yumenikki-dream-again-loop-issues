extends State

func _state_physics_update(_delta: float) -> void: 
	Player.Instance.get_pl().components.get_component_by_name(Player_YN.COMP_MENTAL).bpm = (
		Player.Instance.get_pl().components.get_component_by_name(Player_YN.COMP_MENTAL).calculate_bpm())
		
		
