extends Component

var curr_deadzone: CamDeadzone

func _update(delta: float) -> void:
	if curr_deadzone != null:
		receiver.affector.global_position = receiver.affector.global_position.clamp(
			curr_deadzone.get_min_clamp_pos(), curr_deadzone.get_max_clamp_pos())
