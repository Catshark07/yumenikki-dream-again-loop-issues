class_name Player_YN extends Player

# ----> dependencies
var audio_listener: AudioListener2D
var sound_player: AudioStreamPlayer

@onready var DEFAULT_DATA: PLAttributeData

# ----> trait components

@export var stamina_fsm: FSM
var marker_look_at: Strategist

var sprite_sheet: SerializableDict = preload("res://src/player/2D/madotsuki/display/no_effect.tres")
var action: PLAction 

func _ready() -> void:
	super()
	equip(Instance.equipment_pending, true)

func dependency_components() -> void:	
	audio_listener = $audio_listener
	sound_player = $sound_player
func dependency_setup() -> void:
	stamina_fsm._setup(self) 		# --- fsm; not player dependency but required
	fsm._setup(self)			# --- fsm; not player dependency but required
	
	if components.get_component_by_name("health"):
		components.get_component_by_name("health").took_damage.connect( 
			func(_dmg: float):
				EventManager.invoke_event("PLAYER_HURT", [_dmg]))

func _update(_delta: float) -> void:	
	super(_delta)
	handle_noise()
	if fsm: fsm._update(_delta)
func _physics_update(_delta: float) -> void:
	super(_delta)
	stamina_fsm._physics_update(_delta)
	if fsm: fsm._physics_update(_delta)
func _input_pass(event: InputEvent) -> void:
	if components != null: 	components._input_pass(event)
	if fsm != null: 		fsm._input_pass(event)
	
#region EMOTES, UNIQUE, BEHAVIOUR
func perform_action(_action: PLAction) -> void: 
	components.get_component_by_name("action_manager").perform_action(_action, self)
func cancel_action(_action: PLAction = action) -> void: 
	components.get_component_by_name("action_manager").cancel_action(_action, self)

func equip(_effect: PLSystemData, _skip: bool = false) -> void: 
	components.get_component_by_name("equip_manager").equip(_effect, self, _skip)
func deequip_effect() -> void: 
	components.get_component_by_name("equip_manager").deequip(self)

func get_behaviour() -> PLBehaviour: 
	return components.get_component_by_name("equip_manager").behaviour
#endregion

#region STATES and ANIMATIONS
func force_change_state(_new: String) -> void: fsm.change_to_state(_new)
func get_state_name() -> String: return fsm.get_curr_state_name()

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
