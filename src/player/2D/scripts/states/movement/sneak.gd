extends SentientState
var library_path := "normal"

func _setup() -> void: 
	(sentient as Player).quered_sneak_start.connect(func(): (sentient as Player_YN).force_change_state("sneak"))
	(sentient as Player).quered_sneak_end.connect(func(): (sentient as Player_YN).force_change_state("walk"))
	
func _enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.sneak_noise_mult
	
func update(_delta: float) -> void:
	if sentient.desired_speed <= 0: 
		sentient.force_change_state("idle")
	
func physics_update(_delta: float, ) -> void:	
	sentient.get_behaviour()._sneak(sentient)
	sentient.handle_velocity((sentient as Player).sneak_multiplier)

	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 1.5)
