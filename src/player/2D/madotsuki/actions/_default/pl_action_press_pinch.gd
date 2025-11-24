extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
@export_file("*.tscn") var return_location: String = ""

func _perform(_pl: Player) -> void:
	if DreamManager.global_dream_state != DreamManager.state.DREAM:
		finished.emit()
		return
	
	_pl.deequip_effect()
	_pl.force_change_state("action")
	_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(pinch_animation, 0)
	await _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).finished
	finished.emit()
	
	var seq = SequencerManager.create_sequence("go_to_real_world")
	var invoke_global_event := EVN_InvokeGlobalEvent.new("CUTSCENE_START_REQUEST")
	var stop_bgm 			:= Evn
	seq.add_child(invoke_global_event)
	
	
