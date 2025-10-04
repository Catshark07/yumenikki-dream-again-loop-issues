extends SBState
var library_path := "normal"

func _state_enter() -> void:
	sentient.noise_multi = sentient.walk_noise_mult
	
	if sentient.desired_speed >= sentient.get_calculated_speed(sentient.sprint_multiplier / 1.1):
		request_transition_to("sprint")
		return
	
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
func _state_update(_delta: float) -> void:
	if sentient.desired_speed >= sentient.get_calculated_speed(sentient.sprint_multiplier / 1.1):
		request_transition_to("sprint")

func _state_physics_update(_delta: float) -> void:
	sentient.get_behaviour()._walk(sentient, _delta)
	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 2.3)
