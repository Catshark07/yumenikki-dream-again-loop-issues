extends SBComponent

var sound_player: SoundPlayer
var trauma: ShaderMaterial
var bpm: float = 0

var vol_bpm_multiplier: float = 1
var pit_bpm_multiplier: float = 1

func _setup(_sb: SentientBase = null) -> void:
	trauma = get_node("fx").material
	sound_player = $sound
	sound_player.stream = preload("res://src/audio/se/se_heartbeat.wav")
	sound_player.play()
	
func _update(delta: float) -> void:
	bpm = sentient.components.get_component_by_name(Player_YN.COMP_MENTAL).bpm
	sound_player.volume_db = lerpf(
		sound_player.volume_db, -50 + (1.1 * (bpm - 60)), 
		delta * 3.2)
	sound_player.pitch_scale = lerpf(
		sound_player.pitch_scale, 1 + (0.007 * (bpm - 60)), 
		delta * 3.2)
	
	trauma.set_shader_parameter(
		"blur_amount", 
		lerpf(
			trauma.get_shader_parameter("blur_amount"), 0 + (0.06 * (bpm - 60.0)), 
			delta * 2.25))
	
	vol_bpm_multiplier = (0.225 * (bpm - 60))
	pit_bpm_multiplier = (0.225 * (bpm - 60))


	Audio.adjust_bus_effect( # --- distortion
		"Distorted", 0, 
		"drive", (0.002 * (bpm - 60)))

func set_active(_active: bool = true) -> void:
	if !_active:
		sound_player.mute()
		trauma.set_shader_parameter("blur_amount", 0)
	
	Audio.set_effect_active("Distorted", 0, _active)
	
	super(_active)

func _on_bypass_enabled() -> void:
	sound_player.mute()
	Audio.set_effect_active("Distorted", 0, false)
func _on_bypass_lifted() -> void:
	sound_player.unmute()
	Audio.set_effect_active("Distorted", 0, true)
	
