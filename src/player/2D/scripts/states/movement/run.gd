extends SentientState

@export var sb_sprint: SBSprint

var library_path := "normal"

func _enter_state() -> void: 	
	(sentient as Player_YN).set_texture_using_sprite_sheet("run")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))
	sentient.noise_multi = sentient.run_noise_mult

func update(_delta: float) -> void:
	if sentient.desired_speed <= 0 or sentient.is_exhausted:
		sentient.force_change_state("idle")

func physics_update(_delta: float) -> void:
	sentient.get_behaviour()._run(sentient)
	sentient.handle_velocity((sentient as Player).sprint_multiplier)

	sb_sprint.drain(_delta)
 
