extends SBState

@export var sb_sprint: SBSprint

var library_path := "normal"

func handle_to_run() -> void:
	if (sentient as Player_YN).can_run: 
		request_transition_to("run")

func _setup() -> void: 
	(sentient as Player).quered_sprint_start.connect(handle_to_run)
	(sentient as Player).quered_sprint_end.connect(func(): request_transition_to("walk"))
	
func _enter_state() -> void: 	
	(sentient as Player_YN).set_texture_using_sprite_sheet("run")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))
	sentient.noise_multi = sentient.run_noise_mult

func physics_update(_delta: float) -> void:
	sentient.get_behaviour()._run(sentient)
	sentient.handle_velocity((sentient as Player).sprint_multiplier)

	if sentient.is_exhausted: request_transition_to("walk")
	sb_sprint.drain(_delta)
 
