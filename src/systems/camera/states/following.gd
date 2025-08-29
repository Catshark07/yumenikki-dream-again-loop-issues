extends State

func _state_physics_update(_delta: float) -> void:
	context.curr_follow_strat._follow(
		context, 
		context.curr_target.global_position)
