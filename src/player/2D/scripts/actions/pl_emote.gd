class_name PLEmote
extends PLAction

const EMOTE_PATH := "emote/"
@export var enter_anim: String
@export var exit_anim: String
@export var speed: float = 1

func _enter(_pl: Player) -> void: 
	if  _pl.components.get_component_by_name("animation_manager") != null:
		_pl.components.get_component_by_name("animation_manager").play_animation(str(EMOTE_PATH + enter_anim))
func _exit(_pl: Player) -> void: 
	if  _pl.components.get_component_by_name("animation_manager") != null:
		_pl.components.get_component_by_name("animation_manager").play_animation(str(EMOTE_PATH + exit_anim))

func _perform(_pl: Player) -> bool: 
	_pl.force_change_state("action")
	return true
	
