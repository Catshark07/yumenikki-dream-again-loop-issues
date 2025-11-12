extends SBState

func _state_physics_update(_delta: float) -> void: 
	sentient.handle_velocity()
	sentient.handle_heading()
	
	if !(sentient as NavSentient).nav_agent.is_target_reached() and \
		(sentient as NavSentient).nav_agent.is_target_reachable():

		sentient.handle_direction(
			(sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		
		sentient.vel_input = sentient.direction
		print(fsm.context, " -- ", sentient.vel_input)
	
	else:
		request_transition_to("wander_idle")
