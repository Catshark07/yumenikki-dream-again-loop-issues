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

# ---- ----
static var bloom: bool = false

static var global_screen_effect: WorldEnvironment
static var instance

# ---- process parents ----
static var pausable_parent: CanvasLayer
static var always_parent: CanvasLayer
static var ui_parent: CanvasLayer

# ---- UI ----
static var player_hud: PLHUD
static var options: IngameSettings
static var state_handler: Component

# ---- cinematic ----
static var cinematic_ui: CanvasLayer
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var game_fsm: StrategistFSM

func setup() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
	
	if instance != null: instance.queue_free()
	instance = self
	
	player_hud = PLHUD.instance
	
	global_screen_effect 	= get_node("global_screen_effect")
	pausable_parent 		= get_node("pausable")
	always_parent 			= get_node("always")
	game_fsm 				= get_node("fsm")
	state_handler 			= get_node("state_handler")

	ui_parent 				= get_node("always/ui")
	options 				= get_node("always/pause")
	cinematic_ui 			= get_node("always/cinematic")
	cinematic_bars 			= get_node("always/cinematic/cinematic_bars")

	pausable_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	cinematic_bars.position.y = -45
	cinematic_bars.size.y = 360
	
	global_screen_effect.environment.glow_enabled = bloom
	await Game.scene_manager.setup_complete
	print("eh")
	state_handler._setup()
	
func update(delta: float) -> void: state_handler._update(delta)
func physics_update(delta: float) -> void: state_handler._physics_update(delta)
func input_pass(event: InputEvent) -> void: state_handler._input_pass(event)
	
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
	Game.scene_manager.change_scene_to(_new, pausable_parent, Game)
					
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
static func change_to_state(new_state: String) -> void:
	print("GAME_FSM: %s" % game_fsm._get_curr_state_name()) 
	game_fsm._change_to_state(new_state)
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
