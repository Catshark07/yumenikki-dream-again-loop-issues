class_name PLActionManager 
extends SBComponent

var emote: PLAction:
	get: 
		if !sentient.get_values().emote.is_empty() and ResourceLoader.exists(sentient.get_values().emote):
			return load(sentient.get_values().emote)
		return emote

var curr_action: PLAction

var cooldown: float = .8
var cooldown_timer: Timer

var is_action: bool = false
var can_action: bool = true

signal did_something

func _setup(_sb: SentientBase = null) -> void:
	super(_sb)
	
	cooldown_timer = $timer
	cooldown_timer.wait_time = cooldown
	cooldown_timer.autostart = false
	cooldown_timer.one_shot = true
	
	cooldown_timer.timeout.connect(func(): can_action = true)

	did_something.connect(flag_false_can_action)
	
# - primary actions
func set_emote(_emote: PLEmote) -> void: emote = _emote
# helper
func set_curr_action(_action: PLAction) -> void: curr_action = _action

func perform_action(_action: PLAction, _pl: Player) -> void: 
	if can_action:
		set_curr_action(_action)
		_action._perform(_pl) 
		did_something.emit()
func cancel_action(_action: PLAction, _pl: Player, _force: bool = false) -> void: 
	if _action and (can_action or _force):
		_action._cancel(_pl)
		set_curr_action(null)

# ---- action handles ----
func handle_action_enter() -> void: 
	if curr_action: 
		await curr_action._action_on_enter(sentient)
func handle_action_exit() -> void: 
	if curr_action: 
		await curr_action._action_on_exit(sentient)

func handle_action_input(_input: InputEvent) -> void: 
	if curr_action and can_action: curr_action._action_input(sentient, _input)
func handle_action_phys_update(_delta: float) -> void: 
	if curr_action: curr_action._action_physics_update(sentient, _delta)
func handle_action_update(_delta: float) -> void: 
	if curr_action: curr_action._action_update(sentient, _delta)

func input_pass(event: InputEvent) -> void:
	super(event)
	if 	Input.is_action_just_pressed("pl_emote"): 				
		perform_action(emote, sentient)

# ---- action executes / cancels ----
func flag_false_can_action() -> void: 
	can_action = false
	cooldown_timer.start()
