extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
@export_file("*.tscn") var return_location: String = ""
var pinch_progress: float = 0:
	set(_progress):
		pinch_progress = clampf(_progress, 0, 1) 

func _perform(_pl: Player) -> void:
	if DreamManager.global_dream_state != DreamManager.state.DREAM:
		finished.emit()
		return
	
	pinch_progress = 0
	_pl.deequip_effect()
	_pl.force_change_state("action")
	_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).play_animation(pinch_animation, 0)
	
func _action_update			(_pl: Player, _delta: float) -> void:
	_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).seek(
		pinch_progress * \
		_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).get_animation(pinch_animation).length
	)
		
	if Input.is_action_pressed("pl_primary_action"):
		pinch_progress += (_pl.get_process_delta_time() * _delta) * 50
		if pinch_progress > 0.45:
			_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).play_animation(pinch_animation, 1)
			_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).seek(.45)
			finished.emit()
	
	else:
		pinch_progress -= (_pl.get_process_delta_time() * _delta) * 45
		if pinch_progress <= 0:
			_pl.force_change_state("idle")
			_pl.components.get_component_by_name(Player_YN.COMP_ACTION).cancel_action(_pl)
