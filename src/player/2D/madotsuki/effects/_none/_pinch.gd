extends PLAction

# - ew.
func _perform(_pl: Player) -> bool: 
	super(_pl)
	if SceneManager.curr_scene_resource == load("res://src/levels/_real/real_room_balc/level.tscn"): return false
	(_pl as Player_YN).deequip_effect()
	(_pl as Player_YN).force_change_state("action")
	await (_pl as Player_YN).components.get_component_by_name("animation_manager").play_animation(animation_path)
	SceneManager.change_scene_to(load("res://src/levels/_real/real_room_balc/level.tscn"))
	
	return true
