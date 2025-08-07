class_name GameManager 
extends Node

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

# ---- canvas properties ----
static var panorama_system: PanoramaSystem
static var screen_transition: ScreenTransition

# ---- process parents ----
static var pausable_parent: Node
static var always_parent: Node
static var ui_parent: Node

# ---- UI ----
static var player_hud: PLHUD
static var options: IngameSettings
static var state_handler: Component

# ---- cinematic ----
static var cinematic_bars: TextureRect
static var cb_tween: Tween

# ---- components
static var game_fsm: FSM

func setup() -> void:
	self.process_mode = Node.PROCESS_MODE_INHERIT
	
	if instance != null: instance.queue_free()
	instance = self
	
	player_hud = PLHUD.instance
	
	game_fsm 				= get_node("game_fsm")
	
	global_screen_effect 	= get_node("global_screen_effect")
	pausable_parent 		= get_node("pausable")
	always_parent 			= get_node("always")
	state_handler 			= get_node("state_handler")

	ui_parent 				= get_node("always/ui")
	cinematic_bars 			= get_node("always/ui/cinematic_bars")
	options 				= get_node("always/pause")
	
	panorama_system 		= get_node("panorama_system")
	screen_transition 		= get_node("always/transition_instance")

	pausable_parent.process_mode = Node.PROCESS_MODE_PAUSABLE
	always_parent.process_mode = Node.PROCESS_MODE_ALWAYS
	
	cinematic_bars.position.y = -45
	cinematic_bars.size.y = 360
	
	global_screen_effect.environment.glow_enabled = bloom
	await Game.scene_manager.setup_complete
	panorama_system._setup()
	state_handler.	_setup()
	
func update(_delta: float) -> void: state_handler._update(_delta)
func physics_update(_delta: float) -> void: 
	state_handler._physics_update(_delta)
	panorama_system._physics_update(_delta)
func input_pass(event: InputEvent) -> void: state_handler._input_pass(event)
	
# ---- game functionality ----
static func pause_options(_pause: bool = true) -> void:
	if _pause and !Game.is_paused: change_to_state("pause")
	elif !_pause and Game.is_paused: change_to_state("active")
static func pause(_pause: bool = true) -> void:
	if _pause: Application.pause()
	else: Application.resume()
	
# ---- secondary scene handling (instead of using scenemanager directly) ----
static func change_scene_to(_new: PackedScene) -> void: 
	if _new == null: return
	Game.scene_manager.change_scene_to(_new)
					
# ---- UI stuff ---- 
static func set_control_visibility(_control: Control, _visible: bool) -> void:
	_control.visible = _visible 

static func set_cinematic_bars(_active: bool) -> void: 
	if cb_tween != null: cb_tween.kill()
	cb_tween = cinematic_bars.create_tween()
	cb_tween.set_parallel()
	cb_tween.set_ease(Tween.EASE_OUT)
	cb_tween.set_trans(Tween.TRANS_EXPO)
	
	match _active:
		true:
			cinematic_bars.visible = _active
			cb_tween.tween_property(cinematic_bars, "size:y", 270, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", 0, 1)
		false:
			cb_tween.tween_property(cinematic_bars, "size:y", 360, 1)
			cb_tween.tween_property(cinematic_bars, "position:y", -45, 1)
			await cb_tween.finished
			cinematic_bars.visible = false
static func show_options(_visible: bool) -> void:
	options.visible = _visible

# ---- state based stuff ----
static func change_to_state(new_state: String) -> void:
	game_fsm.change_to_state(new_state)
static func is_in_state(state: String) -> bool: return game_fsm._is_in_state(state)
static func request_transition(_fade_type: ScreenTransition.fade_type) -> void:
	await Game.main_tree.physics_frame
	await screen_transition.request_transition(_fade_type)

# ---- events
# the dictionary consists of the event name and a dictionary that contains: 1) id and 2) subscribers.
# 1) is self explanatory.
# 2) are going to contain callables itself to call them whenever needed.

# the only downside however, is no matter what callable is subscribed to what event
# the event will invoke and call all callables with no exceptions and conditions.
