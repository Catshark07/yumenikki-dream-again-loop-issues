class_name PlEquipManager
extends SBComponent

const IGNORE = [DEFAULT_EFFECT]
const DEFAULT_EFFECT = preload("res://src/player/2D/madotsuki/effects/_none/_default.tres")

var equipped: bool:
	get: return effect_data != null and !(effect_data in IGNORE)

var behaviour: PLBehaviour:
	get:
		if effect_data == null: return DEFAULT_EFFECT.behaviour
		return effect_data.behaviour

var effect_prefab: 	PLEffectComponent 	= null
var effect_data: 	PLEffect 			= null:
	get:
		if effect_data == null: return DEFAULT_EFFECT
		return effect_data
var effect_values: 	PLVariables 		= null:
	get:
		if effect_data == null: return DEFAULT_EFFECT.variables
		return effect_data.variables

func _setup(_sb: SentientBase = null) -> void:
	equip(Player.Instance.equipment_pending, _sb, true)

# ----> equip / de-equip.
func equip(_effect: PLEffect, _pl: Player, _skip: bool = false) -> void:
	if _effect == null or _effect == effect_data: return
		
	if _effect:
		_pl.components.get_component_by_name(Player_YN.COMP_ACTION).cancel_action(
			_pl.components.get_component_by_name(Player_YN.COMP_ACTION).curr_action, _pl, true)
			
		deequip(_pl)
		effect_data = _effect
		
		_pl.sprite_sheet = load(_effect.variables.sprite_override)

		EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", _effect.skip_equip_animation or _skip)
		EventManager.invoke_event("PLAYER_EQUIP", _effect)
		Player.Instance.equipment_pending = _effect
		
		_effect._apply(_pl)
func deequip(_pl: Player, _skip: bool = false) -> void:
	if effect_data:
		EventManager.invoke_event("PLAYER_DEEQUIP_SKIP_ANIM", effect_data.skip_deequip_animation or _skip)
		EventManager.invoke_event("PLAYER_DEEQUIP", Player.Instance.DEFAULT_EQUIPMENT)
		Player.Instance.equipment_pending = Player.Instance.DEFAULT_EQUIPMENT
		
		_pl.components.get_component_by_name(Player_YN.COMP_ACTION).cancel_action(
			_pl.components.get_component_by_name(Player_YN.COMP_ACTION).curr_action, _pl, true)

		if effect_prefab != null: 
			effect_prefab._exit(_pl)
			effect_prefab.queue_free()

		effect_data._unapply(_pl)
		effect_data 	= null
		
		_pl.sprite_sheet = load(_pl.values.sprite_override)

func _physics_update(_delta: float) -> void:
	if effect_data != null: effect_data._effect_phys_update	(sentient, _delta)
func _update(_delta: float) -> void:
	if effect_data != null: effect_data._effect_update		(sentient, _delta)
func _input_pass(event: InputEvent) -> void: 
	if effect_data != null: effect_data._effect_input		(sentient, event)
		
	if Input.is_action_just_pressed("ui_favourite_effect"): 
		if !equipped: 	equip(Player.Instance.equipment_favourite, sentient)
		else:			deequip(sentient)
