class_name GameManager extends Node

## this is meant for when the actual game is played, ONLY under this gamemanager instance.
## although I could go about doing an autoload, it would seem to be less able for dependency injection.
## and it would be code heavy, which would be VERY VERY prone to error. 
const PRE_GAME_SCENES := [
	"res://src/scenes/debug_preload.tscn",
	"res://src/scenes/pre_menu.tscn",
	"res://src/levels/menu/level.tscn"
	]
const MENU_SCENES := [
	"res://src/levels/_neutral/menu/menu.tscn"
]

var scene_changed_listener: EventListener

# ---- ----
static var bloom: bool = false

static var global_screen_effect: WorldEnvironment
static var instance

# ---- process parents ----
static var pausable_parent: CanvasLayer
static var always_parent: CanvasLayer

# ---- UI ----
static var player_hud: PLHUD
static var options: IngameSettings
static var ui_parent: CanvasLayer

# ---- cinematic ----
static var cinematic_ui: CanvasLayer
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var game_fsm: StrategistFSM


# ---- internal setup ----
func _ready() -> void:
	instance = self
	Game.game_manager = self
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
func _input(event: InputEvent) -> void:
	if game_fsm: game_fsm._input_pass(event)
func setup() -> void:
	await Game.main_tree.process_frame
	
	scene_changed_listener = EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)
	player_hud = PLHUD.instance
	
	global_screen_effect 	= get_node("global_screen_effect")
	pausable_parent 		= get_node("pausable")
	always_parent 			= get_node("always")
	game_fsm 				= get_node("fsm")
	
	ui_parent 				= get_node("always/ui")
	options 				= get_node("always/pause")
	cinematic_ui 			= get_node("always/cinematic")
	cinematic_bars 			= get_node("always/cinematic/cinematic_bars")

	game_fsm._setup()
	
	pausable_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	cinematic_bars.position.y = -45
	cinematic_bars.size.y = 360
	
	global_screen_effect.environment.glow_enabled = bloom
	
# ---- game functionality ----
static func pause_options(_pause: bool = true) -> void:
	if _pause: change_to_state("pause")
	else: change_to_state(game_fsm._get_prev_state_name())
static func pause(_pause: bool = true) -> void:
	if _pause: Game.Application.pause()
	else: Game.Application.resume()
	
# ---- secondary scene handling (instead of using scenemanager directly) ----
static func change_scene_to(_new: PackedScene) -> void: 
	if _new == null: return
	if instance: Game.scene_manager.change_scene_to(_new, pausable_parent)
	else: Game.scene_manager.change_scene_to(_new, Global)
					
# ---- UI stuff ---- 
static func set_ui_visibility(_visible: bool) -> void:
	ui_parent.visible = _visible 

static func set_cinematic_bars(_active: bool) -> void: 
	if cb_tween != null: cb_tween.kill()
	cb_tween = cinematic_ui.create_tween()
	cb_tween.set_parallel()
	cb_tween.set_ease(Tween.EASE_OUT)
	cb_tween.set_trans(Tween.TRANS_EXPO)
	
	match _active:
		true:
			cinematic_ui.visible = _active
			cb_tween.tween_property(cinematic_bars, "size:y", 270, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", 0, 1)
		false:
			cb_tween.tween_property(cinematic_bars, "size:y", 360, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", -45, 1)
			await cb_tween.finished
			cinematic_ui.visible = false
static func show_options(_visible: bool) -> void:
	options.visible = _visible

# ---- state based stuff ----
static func change_to_state(new_state: String) -> void: game_fsm._change_to_state(new_state)
static func is_in_state(state: String) -> bool: return game_fsm._is_in_state(state)
static func request_transition(_fade_type: ScreenTransition.fade_type) -> void:
	await Game.main_tree.physics_frame
	await ScreenTransition.request_transition(_fade_type)

# ---- events
# the dictionary consists of the event name and a dictionary that contains: 1) id and 2) subscribers.
# 1) is self explanatory.
# 2) are going to contain callables itself to call them whenever needed.

# the only downside however, is no matter what callable is subscribed to what event
# the event will invoke and call all callables with no exceptions and conditions.
class EventManager:
	static func add_listener(_listener: EventListener, _id: String) -> void:
		create_event(_id)
		GameManager.EventManager.event_ids[_id]["subscribers"].append(_listener)
	static func remove_listener(_listener: EventListener, _id: String) -> void:
		create_event(_id)
		if  GameManager.EventManager.event_ids[_id]["subscribers"].find(_listener) != -1:
			GameManager.EventManager.event_ids[_id]["subscribers"].remove_at(
				GameManager.EventManager.event_ids[_id]["subscribers"].find(_listener)
				)
	static func create_event(_id: String) -> void:
		if !GameManager.EventManager.event_ids.has(_id):
			GameManager.EventManager.event_ids[_id] = {"subscribers" : [], "params" : []}
			return	
		
		if !GameManager.EventManager.event_ids[_id].has("subscribers"):
			GameManager.EventManager.event_ids[_id]["subscribers"] = []
		
		if !GameManager.EventManager.event_ids[_id].has("params"):
			GameManager.EventManager.event_ids[_id]["params"] = []
			
	static func invoke_event(_id: String, _params := []) -> void: 
		create_event(_id)
		GameManager.EventManager.event_ids[_id]["params"] = _params

		for i in range((GameManager.EventManager.event_ids[_id]["subscribers"] as Array[EventListener]).size()):
			if GameManager.EventManager.event_ids[_id]["subscribers"][i].is_valid_listener: 
				GameManager.EventManager.event_ids[_id]["subscribers"][i].on_notify.call_deferred(_id)
			else: 
				remove_listener(GameManager.EventManager.event_ids[_id]["subscribers"][i], _id)
	static func get_event_param(_id: String) -> Array[Variant]:
		create_event(_id)
		if (GameManager.EventManager.event_ids[_id]["params"] as Array).is_empty(): return [null]
		return GameManager.EventManager.event_ids[_id]["params"]

	static var event_ids := {
		# ---- game events -----
		"GAME_MENU" : {},
		"GAME_PAUSE" : {},
		"GAME_CUTSCENE" : {},
		"GAME_ACTIVE" : {},
		"GAME_FILE_SAVE" : {},
		"GAME_CONFIG_SAVE" : {},
		
		# ---- reality states -----
		"REALITY_REAL" : {},
		"REALITY_DREAM" : {},
		"REALITY_NEITHER" : {},
		
		# ---- cutscenes -----
		"CUTSCENE_START" : {},
		"CUTSCENE_END" : {},
		"CUTSCENE_TEMP-START" : {},
		"CUTSCENE_TEMP-END" : {},
		
		# ---- player ----
		"PLAYER_UPDATED" : {},
		
		"PLAYER_MOVE" : {},
		"PLAYER_ACTION" : {},
		"PLAYER_EMOTE" : {},
		"PLAYER_INTERACT" : {},
		"PLAYER_HURT" : {},
		"PLAYER_STAMINA_CHANGE" : {},
		"PLAYER_WAKE-UP" : {},
		
		"PLAYER_EQUIP" : {},
		"PLAYER_DEEQUIP" : {},

		"PLAYER_EFFECT_FOUND" : {},
		"PLAYER_EFFECT_DISCARD" : {},
			
		"PLAYER_DOOR_TELEPORTATION" : {},
			
		"PLAYER_DOOR_USED" : {},
		"PLAYER_SANITY_CHANGE" : {},
		"PLAYER_ADRENALINE_CHANGE" : {},	
		

		# ---- chase events -----
		"PRECHASE_ACTIVE" : {},
		"PRECHASE_FINISH" : {},
		"CHASE_ACTIVE" : {},
		"CHASE_FINISH" : {},

		# ---- scene change invokes -----
		"SCENE_LOADED" : {},
		"SCENE_UNLOADED" : {},
		"SCENE_CHANGE_REQUEST" : {},
		"SCENE_CHANGE_SUCCESS" : {},
		"SCENE_CHANGE_FAIL" : {},
		
		# ---- player special events ;; invert cutscene -----
		"SPECIAL_INVERT_CUTSCENE_BEGIN" : {},
		"SPECIAL_INVERT_CUTSCENE_END" : {},
		
		## WORLD.
		"WORLD_LOOP" : {},
		"WORLD_TIME_DAY" : {},
		"WORLD_TIME_NIGHT" : {},
	}
