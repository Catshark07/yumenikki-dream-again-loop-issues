extends Control

const GAME_VER := "pre_alpha_002"

# ---- windows
var is_paused: bool = false
var root: Window
var main_tree: SceneTree

# ---- time
var true_time_scale: float: 
	set(true_ts): 
		true_time_scale = true_ts
		true_time_scale_changed.emit(true_ts)
var true_delta: float: get = get_real_delta

signal time_scale_changed(_new: float)
signal true_time_scale_changed(_new: float)

# - signals
signal game_ready
signal scene_loaded
signal scene_unloaded

static var game_manager: GameManager

# The main game holds a child node that acts as the scene currently active.
# Upon scene change, remove the current child and queue load for the requested one.

func singleton_setup() -> void: 
	if GameManager.instance == null:
		game_manager = preload("res://src/main/game.tscn").instantiate()
		game_manager.name = "game_manager"
		self.add_child(game_manager)
		
	else:
		game_manager.reparent(self)

func _ready() -> void:
	ProjectSettings.set_setting("application/config/version", GAME_VER)
	
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	
	true_time_scale = Engine.time_scale
		
	main_tree 	= get_tree()
	root 		= get_tree().root
	
	Application.		_setup()
	Audio.				_setup()
	Config.				_setup()
	Directory.			_setup()
	Optimization.		_setup()
	Save.				_setup() 
	InputManager.		_setup()
	SequencerManager.	_setup()
	
	singleton_setup()
	
	await main_tree.process_frame
	
	game_manager.					_setup()
	game_manager.global_components.	_setup()
	SceneManager.					_setup()
	game_manager.state_handle.		_setup()

	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	
	game_ready.emit()
	
func _process(delta: float) -> void: 
	InputManager.		_update(delta)
	SequencerManager.	_update(delta)
	SceneManager.		_update(delta)
	game_manager.		update(delta)
func _physics_process(delta: float) -> void:
	InputManager.		_physics_update(delta)
	SequencerManager.	_physics_update(delta)
	SceneManager.		_physics_update(delta)
	game_manager.		physics_update(delta)
func _input(_event: InputEvent) -> void:
	game_manager.input_pass(_event)
	InputManager._input_pass(_event)
func _unhandled_input(_event: InputEvent) -> void:
	InputManager._unhandled_input_pass(_event)

func get_mouse_position_within_vp() -> Vector2:
	return clamp(Application.main_viewport.get_mouse_position(), Vector2.ZERO, Application.get_viewport_dimens())
func get_mouse_position() -> Vector2:
	return Application.main_viewport.get_mouse_position() - (Application.get_viewport_dimens() / 2)
# ---- rendering server control ----

func lerp_timescale(_new: float):
	var t_tween := self.create_tween() 
	true_time_scale = _new
	t_tween.tween_method(set_timescale, Engine.time_scale, _new, 0.35)
func set_timescale(_new: float) -> void:
	Engine.time_scale = _new
	time_scale_changed.emit(_new)
	
static func change_scene_to(_new: PackedScene) -> void: 
	SceneManager.change_scene_to(_new)
# ---- game values ----	
func get_real_delta() -> float: 
	return (true_time_scale / Engine.max_fps)
func get_real_timescale() -> float:
	return true_time_scale
func get_timescale() -> float: return Engine.time_scale

class GameSubClass:
	extends RefCounted

	static func _setup() -> void: 							pass
	
	static func _update(_delta: float) -> void: 			pass
	static func _physics_update(_delta: float) -> void:	 	pass

	static func _input_pass(_event: InputEvent) -> void: 	pass
