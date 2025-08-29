extends SBState


func _state_physics_update(_delta: float) -> void: 
	if (!(sentient as NavSentient).nav_agent.is_target_reached() and 
		(sentient as NavSentient).nav_agent.is_target_reachable()):

		sentient.handle_direction(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.handle_velocity()
		sentient.vel_input = sentient.direction
	
	
	
	else:
		request_transition_to("wander_idle")
