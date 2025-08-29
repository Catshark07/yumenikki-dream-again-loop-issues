class_name PlEquipManager
extends SBComponent

var equipped: bool:
	get: return effect_data != null and !(effect_data in IGNORE)
var effect_prefab: PLEffectComponent = null
var effect_data: PLEffect = null
var behaviour: PLBehaviour:
	get:
		if effect_data == null: return load("res://src/player/2D/madotsuki/effects/_none/_behaviour.tres")
		else: return effect_data.behaviour

const IGNORE := [preload("res://src/player/2D/madotsuki/effects/_none/_default.tres")]

# ----> equip / de-equip.
func equip(_effect: PLEffect, _pl: Player, _skip: bool = false) -> void:
	if _effect == effect_data:
		return
		
	if _effect:
		_pl.components.get_component_by_name("action_manager").cancel_action(
			_pl.components.get_component_by_name("action_manager").curr_action, _pl, true)
			
		await deequip(_pl)
		effect_data = _effect
		behaviour = effect_data.behaviour
		if 	( 
			!_effect.player_component_prefab.is_empty() and
			ResourceLoader.exists(_effect.player_component_prefab) and 
			load(_effect.player_component_prefab).can_instantiate() 
			):
				effect_prefab = load(_effect.player_component_prefab).instantiate()
				effect_prefab.name = "effect" + _effect.name
				_pl.add_child(effect_prefab)
				effect_prefab._enter(_pl)

		EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", [_effect.skip_equip_animation or _skip])
		EventManager.invoke_event("PLAYER_EQUIP", [_effect])
		Player.Instance.equipment_pending = _effect
		_effect._apply(_pl)
func deequip(_pl: Player, _skip: bool = false) -> void:
	if effect_data in IGNORE: return
	if effect_data:
		EventManager.invoke_event("PLAYER_DEEQUIP_SKIP_ANIM", [effect_data.skip_deequip_animation or _skip])
		EventManager.invoke_event("PLAYER_DEEQUIP", [effect_data])
		Player.Instance.equipment_pending = Player.Instance.DEFAULT_EQUIPMENT
		
		_pl.components.get_component_by_name("action_manager").cancel_action(
			_pl.components.get_component_by_name("action_manager").curr_action, _pl, true)

		if effect_prefab != null: 
			effect_prefab._exit(_pl)
			effect_prefab.queue_free()

		effect_data._unapply(_pl)
		effect_data = Player.Instance.DEFAULT_EQUIPMENT
		Player.Instance.DEFAULT_EQUIPMENT._apply(_pl)
	
func accept(_effect: PLEffect) -> void:
	pass
	
func _physics_update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._physics_update(_delta, sentient)
	if behaviour: behaviour._physics_update(sentient, _delta)
func _update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._update(_delta, sentient)
func _input_pass(event: InputEvent) -> void: 
	if effect_prefab != null: 
		effect_prefab.input(event, sentient)
		
	if Input.is_action_just_pressed("ui_favourite_effect"): 
		if !equipped: 	equip(Player.Instance.equipment_favourite, sentient)
		else:			deequip(sentient)
