extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
var pinch_progress: float = 0:
	set(_progress):
		pinch_progress = clampf(_progress, 0, 1) 

func _perform(_pl: Player) -> void:
	_pl.deequip_effect()
	_pl.force_change_state("action")
	
func _cancel		(_pl: Player) -> void:
	print("WHAT THE FUzCK")

func _action_input(_pl: Player, _input: InputEvent) -> void:
	print(pinch_progress)
	pinch_progress += _pl.get_process_delta_time()
