extends SentientState
var library_path := "normal"

func _setup() -> void: 
	(sentient as Player).quered_sprint_start.connect(handle_to_run)
	(sentient as Player).quered_sprint_end.connect(func(): (sentient as Player_YN).force_change_state("idle"))

func _enter_state() -> void: 	
	super()
	(sentient as Player_YN).set_texture_using_sprite_sheet("run")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "run"))
	sentient.noise_multi = sentient.run_noise_mult
	sentient.speed_multiplier = (sentient as Player).sprint_multiplier

func update(_delta: float) -> void:
	if sentient.desired_speed <= 0: 
		sentient.force_change_state("idle")

func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._run(sentient)
 
	if sentient.is_exhausted: 
		sentient.force_change_state("walk")
		return
	
	if sentient.stamina > 0: sentient.stamina -= (sentient.stamina_drain * sentient.get_process_delta_time()) 	
	elif sentient.stamina < 0:
		sentient.force_change_state("walk")
		sentient.stamina_fsm.change_to_state("exhausted")

func handle_to_run() -> void:
	if (sentient as Player_YN).can_run: (sentient as Player_YN).force_change_state("run")
	
