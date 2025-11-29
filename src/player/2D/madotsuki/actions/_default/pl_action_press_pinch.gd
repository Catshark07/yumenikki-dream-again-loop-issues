extends PLAction

@export var pinch_animation: StringName = &"action/pinch"
@export_file("*.tscn") var return_location: String = "res://src/levels/_real/apartment/level.tscn"

func _perform(_pl: Player) -> void:
	if DreamManager.global_dream_state != DreamManager.state.DREAM:
		finished.emit()
		return
	
	if SceneManager.curr_scene_resource.resource_path == return_location:
		AudioService.play_sound.bind(Player.ERR_SOUNDS.pick_random()) 
		return

	_pl.vel_input = Vector2.ZERO
	_pl.dir_input = Vector2.ZERO
	_pl.velocity = Vector2.ZERO
	
	_pl.deequip_effect()
	_pl.force_change_state("action")
	
	_pl.components.get_component_by_name(Player_YN.Components.ANIMATION).play_animation(pinch_animation, 1)
	await _pl.components.get_component_by_name(Player_YN.Components.ANIMATION).finished
	finished.emit()
	
	var seq = SequencerManager.create_sequence("go_to_real_world")
	var stop_bgm 			:= EVN_StopBGM.new()
	var wait_one_sec 		:= EVN_WaitSeconds.new(.5)
	
	seq.append(stop_bgm, "stop_bgm")
	seq.append(wait_one_sec, "wait_half_sec")
	
	SequencerManager.invoke(seq)
	await seq.finished
	
	SceneManager.change_scene_to(load(return_location))
	
	
