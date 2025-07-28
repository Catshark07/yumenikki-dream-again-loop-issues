extends SentientState
var library_path := "normal"

func enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.sneak_noise_mult
	sentient.speed_multiplier = (sentient as Player).sneak_multiplier
	
	super()
func exit_state() -> void:
	super()
	
func update(_delta: float, ) -> void:
	sentient.handle_direction(sentient.get_marker_direction())
	
func physics_update(_delta: float, ) -> void:	
	sentient.get_behaviour()._sneak(sentient)
	
	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.5)
