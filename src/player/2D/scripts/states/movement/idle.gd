extends SentientState
var library_path := "normal"
var pinch: PLAction

func _setup() -> void:
	pinch = load("res://src/player/2D/madotsuki/effects/_none/_pinch.tres")

func _enter_state() -> void: 
	(sentient as Player_YN).set_texture_using_sprite_sheet("idle")
	sentient.components.get_component_by_name("animation_manager").play_animation(str(library_path, '/', "idle"))
	sentient.noise_multi = sentient.walk_noise_mult
	sentient.velocity = Vector2.ZERO
	sentient.speed_multiplier = 0

func update(_delta: float) -> void:
	if sentient.desired_speed > 0:
		sentient.force_change_state("walk")

func physics_update(_delta: float) -> void:
	sentient.get_behaviour()._idle(sentient)
	if sentient.stamina < sentient.MAX_STAMINA:
		sentient.stamina += _delta * (sentient.stamina_regen)
	
func input(_event: InputEvent) -> void: 
	if Input.is_action_just_pressed("emote"):
			sentient.perform_action(sentient.components.get_component_by_name("action_manager").emote)
	if Input.is_action_just_pressed("pinch"):
			sentient.perform_action(pinch)
	
