extends SBState

@export var sb_sprint: SBSprint

var library_path := "normal"

func _state_enter() -> void: 	
	(sentient as Player_YN).set_texture_using_sprite_sheet("run")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))
	sentient.noise_multi = sentient.sprint_noise_mult

func _state_physics_update(_delta: float) -> void:
	sentient.get_behaviour()._run(sentient)
	sentient.handle_velocity((sentient as Player).speed_multiplier)
	
	if	sentient.desired_speed < sentient.get_calculated_speed(sentient.sprint_multiplier / 1.5) or \
		sentient.can_sprint == false: 
			request_transition_to("walk")
	sb_sprint.drain(_delta)
