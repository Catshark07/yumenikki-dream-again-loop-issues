extends SentientState
var library_path := "normal"

func _enter_state() -> void:
	if sentient.get_behaviour().auto_run: 
		fsm.change_to_state("run")
	
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.walk_noise_mult
	sentient.speed_multiplier = (sentient as Player).walk_multiplier
	
func update(_delta: float, ) -> void:
	if sentient.desired_speed <= 0:
		sentient.force_change_state("idle")
	
	if sentient.is_exhausted:  sentient.speed_multiplier = (sentient as Player).exhaust_multiplier
	else					:  sentient.speed_multiplier = (sentient as Player).walk_multiplier
	
	
func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._walk(sentient)

	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 2.3)

	
