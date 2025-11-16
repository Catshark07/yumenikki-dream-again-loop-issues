class_name PLActionManager 
extends SBComponent

# - actions
const PINCH_ACTION: PLAction = preload("res://src/player/2D/madotsuki/actions/hold_to_pinch.tres")

var curr: 	PLAction
var emote: 	PLAction:
	get: return load(sentient.values.emote)

# - other props
@export var cooldown_timer: Timer
var cooldown: float = 1.5
var in_cooldown: bool = false

# - signals
signal did_something


func _setup(_sb: SentientBase = null) -> void: 
	super(_sb)
	
	cooldown_timer.autostart 	= false
	cooldown_timer.one_shot 	= true
	cooldown_timer.wait_time 	= cooldown
	
	Utils.connect_to_signal(restrict_action, did_something)
	Utils.connect_to_signal(func(): in_cooldown = false, cooldown_timer.timeout)

func _update(_delta: float) -> void: 			
	if curr != null: curr._action_update(sentient, _delta)
func _physics_update(_delta: float) -> void: 	
	if curr != null: curr._action_physics_update(sentient, _delta)

func _input_pass(_event: InputEvent) -> void: 
	if curr != null:  curr._action_input(sentient, _event)
	
	
	elif	Input.is_action_just_pressed("pl_emote"): perform_action(sentient, emote)
	elif 	Input.is_action_just_pressed("pl_primary_action"): 
		if !sentient.components.get_component_by_name(Player_YN.Components.EQUIP).effect_data: return	
		sentient.components.get_component_by_name(Player_YN.Components.EQUIP).effect_data._primary_action(sentient)
	elif 	Input.is_action_just_pressed("pl_secondary_action"): 
		if !sentient.components.get_component_by_name(Player_YN.Components.EQUIP).effect_data: return
		sentient.components.get_component_by_name(Player_YN.Components.EQUIP).effect_data._secondary_action(sentient)

func perform_action(_pl: Player, _action: PLAction) -> void:
	if in_cooldown: return 
	if curr != null:
		cancel_action(sentient)
		return
		
	Utils.connect_to_signal(empty_action, _action.finished)
	did_something.emit()
	curr = _action
	curr._perform(_pl) 

func cancel_action(_pl: Player, _force: bool = false) -> void:
	if 	curr != null:
		Utils.disconnect_from_signal(empty_action, curr.finished)
		did_something.emit()
		
		match _force:
			true:			curr._force_cancel(_pl)
			_: 		await 	curr._cancel(_pl)
		
	await Game.main_tree.process_frame
	curr = null

func restrict_action() -> void:
	in_cooldown = true
	cooldown_timer.start()

func empty_action() -> void: curr = null
