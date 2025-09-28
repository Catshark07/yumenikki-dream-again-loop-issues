class_name Player_YN extends Player

# - component IDS
const COMP_ANIMATION 	:= &"animation_manager"
const COMP_ACTION 		:= &"action_manager"
const COMP_SPRITE 		:= &"sprite_manager"
const COMP_EQUIP 		:= &"equip_manager"
const COMP_INTERACT 	:= &"interaction_manager"
const COMP_MENTAL 		:= &"mental_status"
const COMP_FOOTSTEP 	:= &"footstep_manager"

# - dependencies.
var audio_listener: AudioListener2D
var sound_player: AudioStreamPlayer

# - trait components
var global_components: SBComponentReceiver

var sprite_sheet: SerializableDict = preload("res://src/player/2D/madotsuki/display/no_effect.tres"):
	set(sheet):
		sprite_sheet = sheet
		set_texture_using_sprite_sheet(sprite_id)
var sprite_id: String = ""
var action: PLAction 

func _ready() -> void:
	super()
	equip(Instance.equipment_pending, true)
	
	Utils.connect_to_signal(handle_sprint, 	quered_sprint_start)
	Utils.connect_to_signal(handle_sneak, 	quered_sneak_start)
	
	Utils.connect_to_signal(handle_walk, 	quered_sprint_end)
	Utils.connect_to_signal(handle_walk, 	quered_sneak_end)
	
func _enter() -> void:
	super()
	if GameManager.global_player_components != null: 
		global_components = GameManager.global_player_components
		global_components._setup(self)

func dependency_components() -> void:	
	audio_listener = $audio_listener
	sound_player = $sound_player
func dependency_setup() -> void:
	fsm._setup(self)			# --- fsm; not player dependency but required

func _update(_delta: float) -> void:	
	super(_delta)
	handle_noise()
	if fsm: fsm._update(_delta)
	if global_components != null: global_components._update(_delta)
func _physics_update(_delta: float) -> void:
	super(_delta)
	if fsm: fsm._physics_update(_delta)
	if global_components != null: global_components._physics_update(_delta)
func _sb_input(event: InputEvent) -> void:
	if components != null: 	components._input_pass(event)
	if fsm != null: 		fsm._input_pass(event)
	
#region EMOTES, UNIQUE, BEHAVIOUR
func perform_action(_action: PLAction) -> void: 
	components.get_component_by_name(Player_YN.COMP_ACTION).perform_action(_action, self)
func cancel_action(_action: PLAction = action) -> void: 
	components.get_component_by_name(Player_YN.COMP_ACTION).cancel_action(_action, self)

func equip(_effect: PLEffect, _skip: bool = false) -> void: 
	components.get_component_by_name("equip_manager").equip(_effect, self, _skip)
func deequip_effect() -> void: 
	components.get_component_by_name("equip_manager").deequip(self)

func get_behaviour() -> PLBehaviour: 
	return components.get_component_by_name("equip_manager").behaviour
#endregion

#region STATES and ANIMATIONS

func play_sound(_sound: AudioStreamWAV, _vol: float, _pitch: float) -> void:
	if sound_player != null: sound_player.play_sound(_sound, _vol, _pitch)
func set_texture_using_sprite_sheet(_sprite_id: String) -> void:
	sprite_id = _sprite_id
	sprite_renderer.texture = (
			(sprite_sheet.dict[_sprite_id] if 
			sprite_sheet.dict.has(_sprite_id) else 
			preload("res://src/images/missing.png")))
func set_sprite_sheet(_new_sheet: SerializableDict) -> void:
	sprite_sheet = _new_sheet
#endregion
