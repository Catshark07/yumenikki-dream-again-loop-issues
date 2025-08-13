extends SentientState

func _enter_state() -> void: 
	sentient.components.get_component_by_name("action_manager").handle_action_enter()
func _exit_state() -> void: 
	sentient.components.get_component_by_name("action_manager").handle_action_exit()
	
func update(_delta: float) -> void: 
	sentient.components.get_component_by_name("action_manager").handle_action_update(_delta)
func physics_update(_delta: float) -> void: 
	sentient.components.get_component_by_name("action_manager").handle_action_phys_update(_delta)
func input(event: InputEvent) -> void: 
	sentient.components.get_component_by_name("action_manager").handle_action_input(event)
