class_name Player_YN extends Player

# ----> dependencies
var audio_listener: AudioListener2D
var sound_player: AudioStreamPlayer

@onready var DEFAULT_EFFECT: PLEffect = load("res://src/player/2D/madotsuki/effects/_none/_default.tres")
@onready var behaviour: PLBehaviour = load("res://src/player/2D/madotsuki/effects/_none/_behaviour.tres")

# ----> trait components

@export var stamina_fsm: FSM
@export var input_fsm: SentientFSM
var marker_look_at: Strategist

var sprite_sheet: SerializableDict = preload("res://src/player/2D/madotsuki/display/no_effect.tres")
var action: PLAction 

func dependency_components() -> void:	
	audio_listener = $audio_listener
	sound_player = $sound_player
	marker_look_at = $look_at
	
func dependency_setup() -> void:
	if Instance.equipment_pending == null:
		equip.call_deferred(DEFAULT_EFFECT)
		
	marker_look_at._setup()		# --- fsm; not player dependency but required
	stamina_fsm._setup(self) 		# --- fsm; not player dependency but required
	input_fsm._setup(self) 		# --- fsm; not player dependency but required
	fsm._setup(self)			# --- fsm; not player dependency but required
	
	if components.get_component_by_name("health"):
		components.get_component_by_name("health").took_damage.connect( 
			func(_dmg: float):
				EventManager.invoke_event("PLAYER_HURT", [_dmg]))

func get_marker_direction() -> Vector2: 
	return marker_look_at.position
func set_marker_direction_mode(_new_mode: Strategy) -> void: 
	assert(_new_mode is Strategy)
	marker_look_at._change_strat(_new_mode)

#region PROCESS and INPUT
func _update(_delta: float) -> void:	
	super(_delta)
	handle_noise()
	input_fsm._update(_delta)
	if fsm: fsm._update(_delta)
func _physics_update(_delta: float) -> void:
	super(_delta)
	stamina_fsm._physics_update(_delta)
	if behaviour: behaviour._physics_update(self, _delta)
	if fsm: fsm._physics_update(_delta)
func _input_pass(event: InputEvent) -> void:
	dependency_input(event)
	if fsm: fsm._input_pass(event)
	
func dependency_input(event: InputEvent) -> void:
	if components != null: 
		components._input_pass(event)
#endregion

#region EMOTES, UNIQUE, BEHAVIOUR
func perform_action(_action: PLAction) -> void: 
	components.get_component_by_name("action_manager").perform_action(_action, self)
func cancel_action(_action: PLAction = action) -> void: 
	components.get_component_by_name("action_manager").cancel_action(_action, self)

func equip(_effect: PLEffect) -> void: 
	components.get_component_by_name("equip_manager").equip(_effect, self)
func deequip_effect(_skip_anim: bool = false) -> void: 
	components.get_component_by_name("equip_manager").deequip(self)

func set_behaviour(_beh: PLBehaviour) -> void:
	behaviour = _beh
func revert_def_behaviour() -> void: behaviour = DEFAULT_EFFECT.behaviour
func get_behaviour() -> PLBehaviour: 
	if behaviour == null: return DEFAULT_EFFECT.behaviour
	return behaviour
#endregion

#region STATES and ANIMATIONS
func force_change_state(_new: String) -> void: fsm._change_to_state(_new)
func get_state_name() -> String: return fsm._get_curr_state_name()

func play_sound(_sound: AudioStreamWAV, _vol: float, _pitch: float) -> void:
	if sound_player != null: sound_player.play_sound(_sound, _vol, _pitch)
func set_texture_using_sprite_sheet(_sprite_id: String) -> void:
	sprite_renderer.texture = (
			(sprite_sheet.dict[_sprite_id] if 
			sprite_sheet.dict.has(_sprite_id) else 
			preload("res://src/images/missing.png"))
		)
func set_sprite_sheet(_new_sheet: SerializableDict) -> void:
	sprite_sheet = _new_sheet
	set_texture_using_sprite_sheet(get_state_name())
#endregion
