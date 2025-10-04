extends SBNestedState

func _enter_sub_state() -> void: 
	set_sub_state("walk")

func _update_sub_state(_delta: float) -> void:
	if sentient.desired_speed <= 0: 
		request_transition_to("idle")
	
func _physics_update_sub_state(_delta: float) -> void:
	sentient.handle_heading()
	sentient.handle_velocity()
