class_name PlEquipManager
extends SBComponent

var effect_prefab: PLPhysicalEff = null
var effect_data: PLEffect = null

# ----> equip / de-equip.
func equip(_ef: PLEffect, _pl: Player) -> void:
	if _ef == effect_data:
		await deequip(_pl)
		return
	if _ef:
		await deequip(_pl)
		effect_data = _ef
		if 	( 
			!_ef.player_component_prefab.is_empty() and
			ResourceLoader.exists(_ef.player_component_prefab) and 
			load(_ef.player_component_prefab).can_instantiate() 
			):
				effect_prefab = load(_ef.player_component_prefab).instantiate()
				effect_prefab.name = "effect" + _ef.name
				_pl.add_child(effect_prefab)
				effect_prefab._enter(_pl)

		EventManager.invoke_event("PLAYER_EQUIP_SKIP_ANIM", [_ef.skip_equip_animation])
		EventManager.invoke_event("PLAYER_EQUIP", [_ef])
		Player.Instance.equipment_pending = _ef
		_ef._apply(_pl)
		
func deequip(_pl: Player) -> void:
	if effect_data:
		EventManager.invoke_event("PLAYER_DEEQUIP_SKIP_ANIM", [effect_data.skip_deequip_animation])
		EventManager.invoke_event("PLAYER_DEEQUIP", [effect_data])
		Player.Instance.equipment_pending = null
		
		_pl.components.get_component_by_name("action_manager").cancel_action(
			_pl.components.get_component_by_name("action_manager").curr_action, _pl, true)

		if effect_prefab != null: 
			effect_prefab._exit(_pl)
			effect_prefab.queue_free()

		effect_data._unapply(_pl)
		effect_data = null
		
		equip(_pl.DEFAULT_EFFECT, _pl)
func _input_effect(_input: InputEvent, _pl: Player) -> void: 
	if effect_prefab != null: effect_prefab.input(_input, _pl)
	
func _physics_update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._physics_update(_delta, sentient)
func _update(_delta: float) -> void:
	if effect_prefab != null: effect_prefab._update(_delta, sentient)
	
func _input_pass(event: InputEvent) -> void: 
	_input_effect(event, sentient)
	if Input.is_action_just_pressed("favourite_effect"):
		equip(PLInventory.favourite_effect, sentient)
