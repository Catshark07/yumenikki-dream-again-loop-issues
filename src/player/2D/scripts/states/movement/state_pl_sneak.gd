extends SBState
var library_path := "normal"
	
func _state_enter() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.sneak_noise_mult
	
func _state_physics_update(_delta: float) -> void:	
	sentient.get_behaviour()._sneak(sentient)

	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.5)
