extends State

var change_tween: Tween
var target_position: Vector2

func physics_update(_delta: float) -> void: 
	target_position = context.curr_target.global_position
	context.global_position = (
		Tween.interpolate_value(
			context.global_position, 
			target_position - context.global_position,
			_delta,
			context.switch_duration,
			Tween.TRANS_EXPO, 
			Tween.EASE_OUT)
			)
	
	if is_zero_approx(Vector2(target_position - context.global_position.round()).length()):
		fsm.change_to_state("following") 
