extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
var pinch_progress: float = 0:
	set(_progress):
		pinch_progress = clampf(_progress, 0, 1) 

func _perform(_pl: Player) -> void:
	_pl.deequip_effect()
	_pl.force_change_state("action")

func _action_input(_pl: Player, _input: InputEvent) -> void:
	if _input.is_action_pressed("pl_primary_action"): 
		print(pinch_progress)
		pinch_progress += _pl.get_process_delta_time()
	else:
		pinch_progress -= _pl.get_process_delta_time() * 0.9
