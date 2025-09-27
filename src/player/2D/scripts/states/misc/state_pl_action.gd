extends SBState

func _state_enter() -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_ACTION).handle_action_enter()
func _state_exit() -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_ACTION).handle_action_exit()
	
func _state_update(_delta: float) -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_ACTION).handle_action_update(_delta)
func _state_physics_update(_delta: float) -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_ACTION).handle_action_phys_update(_delta)
func _state_input(event: InputEvent) -> void: 
	sentient.components.get_component_by_name(Player_YN.COMP_ACTION).handle_action_input(event)
