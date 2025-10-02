extends SBNestedState

func _enter_sub_state() -> void: 
	set_sub_state("walk")

func _update_sub_state(_delta: float) -> void:
	if sentient.desired_speed <= 0: 
		request_transition_to("idle")
	
	elif sentient.desired_speed < sentient.get_calculated_speed(sentient.sprint_multiplier / 1.5) or \
		sentient.can_sprint == false: 
			request_transition_to("walk")
			
	elif (sentient.desired_speed >= \
		sentient.get_calculated_speed(sentient.sprint_multiplier) and sentient.can_sprint):
			request_transition_to("sprint")
	
func _physics_update_sub_state(_delta: float) -> void:
	sentient.handle_heading()
	sentient.handle_velocity()
