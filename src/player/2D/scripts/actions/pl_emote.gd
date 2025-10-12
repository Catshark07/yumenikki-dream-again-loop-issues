class_name PLEmote
extends PLAction

const EMOTE_PATH := "emote/"
@export var enter_anim: StringName
@export var exit_anim: StringName
@export var speed: float = 1

func _action_on_enter(_pl: Player) -> void: 
	can_exit = false
	if  _pl.components.get_component_by_name("animation_manager") != null:
		_pl.components.get_component_by_name("animation_manager").play_animation(str(EMOTE_PATH + enter_anim))
		await _pl.components.get_component_by_name("animation_manager").animation_player.animation_finished
		can_exit = true

func _action_on_request_exit(_pl: Player) -> void:
	if  _pl.components.get_component_by_name(Player_YN.COMP_ANIMATION) != null:
		_pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).play_animation(str(EMOTE_PATH + exit_anim))
		await _pl.components.get_component_by_name(Player_YN.COMP_ANIMATION).animation_player.animation_finished
		_cancel(_pl)
		
func _action_update(_pl: Player, _delta: float) -> void: 
	if _pl.desired_speed > 0 or Input.is_action_just_pressed("pl_emote"):
		request_exit(_pl)
		
	if 	_pl.stamina < _pl.MAX_STAMINA:
		_pl.stamina += _delta * (_pl.values.stamina_regen / 1.5)

func _perform(_pl: Player) -> void: _pl.force_change_state("action")
func _cancel(_pl: Player) -> void: 	_pl.force_change_state("idle")
