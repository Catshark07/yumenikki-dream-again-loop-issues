extends SBState
var library_path := "normal"

func _enter_state() -> void:
	if sentient.get_behaviour().auto_run: 
		request_transition_to("run")
		return
		
	(sentient as Player_YN).set_texture_using_sprite_sheet("walk")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "walk"))
	sentient.noise_multi = sentient.walk_noise_mult
	
func update(_delta: float) -> void:
	if sentient.desired_speed >= (sentient.sprint_multiplier * sentient.BASE_SPEED) and sentient.can_run:
		request_transition_to("run")
	if sentient.get_behaviour().auto_run: 
		request_transition_to("run")
		return

func physics_update(_delta: float) -> void:
	if sentient.is_exhausted:  	sentient.handle_velocity((sentient as Player).sneak_multiplier)
	else:						sentient.handle_velocity((sentient as Player).walk_multiplier)
	
	sentient.get_behaviour()._walk(sentient)

	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen / 2.3)
