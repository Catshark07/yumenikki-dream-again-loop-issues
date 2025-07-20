extends Control

var scene_manager: SceneManager

# ---- windows
var root: Window
var main_tree: SceneTree

var is_paused: bool
# ---- time
var true_time_scale: float:
	set(true_ts): 
		true_time_scale = true_ts
		true_time_scale_changed.emit(true_ts)
var true_delta: float

var time_elapsed: float

signal time_scale_changed(_new: float)
signal true_time_scale_changed(_new: float)

static var game_manager

# ---- audio
var true_music_volume: float = 0
var true_ambience_volume: float = 0
var true_sfx_volume: float = 0

# The main game holds a child node that acts as the scene currently active.
# Upon scene change, remove the current child and queue load for the requested one.

func singleton_setup() -> void: 
	scene_manager = SceneManager.new()
	
	if GameManager.instance == null:
		game_manager = preload("res://src/main/game.tscn").instantiate()
		game_manager.name = "game_manager"
		self.add_child(game_manager)
		print(game_manager)
		
	else:
		game_manager.reparent(self)

func _ready() -> void:
	true_time_scale = Engine.time_scale
	
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	time_elapsed = 0
		
	root = get_tree().root
	main_tree = get_tree()
	
	Application._setup()
	Audio._setup()
	Config._setup()
	Directory._setup()
	Optimization._setup()
	Save._setup() 
	
	singleton_setup()
	
	await main_tree.process_frame
	
	game_manager.setup()
	scene_manager.setup()
	GlobalPanoramaManager.setup()
	
	set_process(true)
	set_physics_process(true)
	set_process_input(true)
	
func _process(delta: float) -> void: 
	GlobalPanoramaManager.update(delta)
	true_delta = get_real_delta()
	true_time_scale = get_real_timescale()
	game_manager.update(delta)
func _physics_process(delta: float) -> void:
	game_manager.physics_update(delta)
func _input(event: InputEvent) -> void:
	game_manager.input_pass(event)	

func get_play_time() -> Dictionary:
	return {
		"hours" 	: floori(fmod(time_elapsed / 3600, 24)),
		"minutes" 	: floori(fmod(time_elapsed, 3600) / 60),
		"seconds" 	: floori(fmod(fmod(time_elapsed, 3600), 60))
	}
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
	
# ---- game values ----	
func get_real_delta() -> float: 
	return (true_time_scale / Engine.max_fps)
func get_real_timescale() -> float:
	return true_time_scale
func get_timescale() -> float: return Engine.time_scale
	
class Save:
	extends GameSubClass
	static var data := {
	"game" : {
		"version" : "00",
		"read_warning" : false,
		"time_played" : 00,
		},
	"player" : {},
	"scene" : {}}
		
	static var curr_data: Dictionary
	const SAVE_DIR := "user://save/"
	
	static func _setup() -> void:
		if DirAccess.dir_exists_absolute("user://save"): pass
		else: DirAccess.make_dir_absolute("user://save")
	
	static func save_data(_number: int = 0) -> Dictionary:
		DirAccess.make_dir_absolute(SAVE_DIR)
		
		if curr_data.is_empty(): curr_data = Dictionary(data)
		var save_file := FileAccess.open(str(SAVE_DIR, "save_%s.json" % [_number]), FileAccess.WRITE)
		var curr_data := Dictionary(data)
		
		curr_data["game"]["version"] = ProjectSettings.get_setting("application/config/version")
		curr_data["game"]["time_played"] = {
			"hours" 	: Game.get_play_time()["hours"],
			"minutes" 	: Game.get_play_time()["minutes"], 
			"seconds" 	: Game.get_play_time()["seconds"]
			}
			
		curr_data["player"] = Player.Data.get_data()
		curr_data["scene"] = NodeSaveService.get_data()
		
		print(save_file.get_path())
		save_file.store_string(JSON.stringify(curr_data, "\t"))
		save_file.close()
		save_file = null
		
		EventManager.invoke_event("GAME_FILE_SAVE")
		return curr_data
	static func load_data(_number: int = 0) -> Error:
		if FileAccess.file_exists(str(SAVE_DIR, "save_%s.json" % [_number])): 
			var load_file := FileAccess.open(str(SAVE_DIR, "save_%s.json" % [_number]), FileAccess.READ)
			var content = JSON.parse_string(load_file.get_as_text())
			curr_data = content
			
			print(load_file.get_path())
			
			load_file.close()
			load_file = null
			
			Player.Data.set_data(content["player"])
			NodeSaveService.set_data(content["scene"])
			
		else: return ERR_CANT_OPEN
		return OK

	static func get_curr_data() -> Dictionary:
		if curr_data.is_empty(): return data
		return curr_data
		
	static func get_data_as_json(_json_file_name: String) -> JSON:
		var json_file_path := str(SAVE_DIR, "%s.json" % [_json_file_name])
		if json_file_path.is_empty() or json_file_path == ".json": return
		
		return ResourceLoader.load(json_file_path)

	static func clear_data() -> Error:
		data["player"] = {}
		data["scene"] = {}
		data["game"]["read_warning"] = false
		return OK

	static func change_data_value(_key: String, _val: Variant) -> void:
		if !_key in data: return
		data[_key] = _val 
	static func read_data_value(_key: String) -> Variant:
		if !_key in data: return
		return data[_key]
class Config: 
	extends GameSubClass
	static func _setup() -> void:
		instantiate_config()
		load_settings_data()
	
	static var config_data := ConfigFile.new()
	
	static func instantiate_config() -> void:
		if get_setting_data("misc", "instantiated", true): return
		
		config_data.set_value("misc", "instantiated", true)
		
		config_data.set_value("audio", "music", db_to_linear(Audio.get_bus_volume("Music")))
		config_data.set_value("audio", "ambience", db_to_linear(Audio.get_bus_volume("Ambience")))
		config_data.set_value("audio", "se", db_to_linear(Audio.get_bus_volume("Effects")))
		
		config_data.set_value("graphics", "borderless", Game.main_window.borderless)
		config_data.set_value("graphics", "fullscreen", Game.main_window.mode == Window.MODE_FULLSCREEN)
		config_data.set_value("graphics", "motion_reduce", CameraHolder.motion_reduction)
		config_data.set_value("graphics", "bloom", GameManager.bloom)
		
		config_data.save("user://settings.cfg")
	
	static func save_settings_data() -> void: 
		EventManager.invoke_event("GAME_CONFIG_SAVE")
		
		config_data.set_value("audio", "music", db_to_linear(Audio.get_bus_volume("Music")))
		config_data.set_value("audio", "ambience", db_to_linear(Audio.get_bus_volume("Ambience")))
		config_data.set_value("audio", "se", db_to_linear(Audio.get_bus_volume("Effects")))
		
		config_data.set_value("graphics", "borderless", Game.Application.main_window.borderless)
		config_data.set_value("graphics", "fullscreen", Game.Application.main_window.mode == Window.MODE_FULLSCREEN)
		config_data.set_value("graphics", "motion_reduce", CameraHolder.motion_reduction)
		config_data.set_value("graphics", "bloom", GameManager.bloom)
		
		config_data.save("user://settings.cfg")
	static func load_settings_data() -> void: 
		var s = config_data.load("user://settings.cfg")
		if s != OK: return
		
		Audio.adjust_bus_volume("Music", config_data.get_value("audio", "music"))
		Audio.adjust_bus_volume("Ambience", config_data.get_value("audio", "ambience"))
		Audio.adjust_bus_volume("Effects", config_data.get_value("audio", "se"))
		
		Game.Application.main_window.borderless = config_data.get_value("graphics", "borderless")
		Game.Application.main_window.mode = Window.MODE_FULLSCREEN if config_data.get_value("graphics", "fullscreen") else Window.MODE_WINDOWED
		CameraHolder.motion_reduction = config_data.get_value("graphics", "motion_reduce")
		GameManager.bloom = config_data.get_value("graphics", "bloom")
		
	static func get_setting_data(_section: String, _setting: String, _default: Variant = 0) -> Variant:
		var s = config_data.load("user://settings.cfg")
		if s != OK: return
		
		if config_data.has_section(_section) and config_data.has_section_key(_section, _setting):
			return config_data.get_value(_section, _setting)
		return _default
class Application: 
	extends GameSubClass
	static func _setup() -> void:
		main_window = Game.main_tree.root.get_window()
		main_viewport = Game.main_tree.root.get_viewport()
		window_setup()
		viewport_setup()
		render_server_setup()
		
	static var viewport_width: int
	static var viewport_length: int
	static var viewport_content_scale: float
	static var main_window: Window
	static var main_viewport: Viewport
	
	static func quit(): 
		Optimization.set_max_fps(30)
		
		if Game.game_manager != null:
			Game.game_manager.process_mode = Node.PROCESS_MODE_DISABLED
		Music.fade_out()
		Ambience.fade_out()
		await Game.Save.save_data()
		await GameManager.request_transition(ScreenTransition.fade_type.FADE_IN)
		Game.main_tree.quit.call_deferred()
	static func pause(): 
		Game.main_tree.paused = true
		Game.is_paused = true
	static func resume(): 
		Game.main_tree.paused = false
		Game.is_paused = false
	
	static func get_viewport_width() -> int: return ProjectSettings.get("display/window/size/viewport_width")
	static func get_viewport_height() -> int: return ProjectSettings.get("display/window/size/viewport_height")		
	static func get_viewport_dimens(_account_content_scale: bool = false) -> Vector2: 
		if _account_content_scale: return Vector2(viewport_width, viewport_length) / viewport_content_scale
		else: return Vector2(viewport_width, viewport_length)
	static func viewport_setup() -> void:
		
		viewport_width = get_viewport_width()
		viewport_length = get_viewport_height()
		viewport_content_scale = ProjectSettings.get("display/window/stretch/scale")
	
		main_window.focus_exited.connect(func(): 
			Game.main_tree.paused = true
			Music.stream_paused = true
			Ambience.stream_paused = true)
		main_window.focus_entered.connect(func(): 
			Game.main_tree.paused = false
			Music.stream_paused = false
			Ambience.stream_paused = false)
	
	static func window_setup() -> void:
		Engine.max_fps = 60
		ProjectSettings.set_setting("rendering/textures/canvas_textures/default_texture_repeat", CanvasItem.TEXTURE_REPEAT_MIRROR)
		
		main_window.content_scale_size = Vector2(960, 540)
		main_window.size = Vector2(960, 540)
		main_window.content_scale_factor = 2
		
		main_window.content_scale_stretch = Window.CONTENT_SCALE_STRETCH_FRACTIONAL
		main_window.position = DisplayServer.screen_get_size(DisplayServer.get_primary_screen()) / 2 - main_window.size / 2 
		
		main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	static func change_window_mode(new_mode: Window.Mode) -> void: main_window.mode = new_mode
	static func set_window_borderless(_brd: bool = true) -> void: main_window.borderless = _brd
	
	static func render_server_setup() -> void:
		RenderingServer.set_default_clear_color(Color.BLACK)
	
class Audio: 
	extends GameSubClass
	static func adjust_bus_volume(_bus_name: String, _vol: float) -> void:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:
			AudioServer.set_bus_volume_db(AudioServer.get_bus_index(_bus_name), linear_to_db(_vol))
	static func get_bus_volume(_bus_name: String) -> float:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:
			return AudioServer.get_bus_volume_db(AudioServer.get_bus_index(_bus_name))
		return 0

	static func adjust_bus_effect(_bus_name: String, _fx_indx: int, _fx_prop: String, _new_val: Variant):
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx).set(_fx_prop, _new_val)	
	static func add_bus_effect(_bus_name: String, _fx: AudioEffect) -> void:
		if (AudioServer.get_bus_index(_bus_name)) >= 0:			
			AudioServer.add_bus_effect(AudioServer.get_bus_index(_bus_name), _fx)
	static func remove_bus_effect(_bus_name: String, _fx_indx: int) -> void:
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.remove_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)
	static func set_effect_active(_bus_name: String, _fx_indx: int, _active: bool) -> void:
		if ((AudioServer.get_bus_index(_bus_name)) >= 0 and 
			AudioServer.get_bus_effect_count(AudioServer.get_bus_index(_bus_name)) - 1 >= _fx_indx and
			AudioServer.get_bus_effect(AudioServer.get_bus_index(_bus_name), _fx_indx)):
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index(_bus_name), _fx_indx, _active)
class Optimization:
	extends GameSubClass
	
	static func _setup() -> void: 
		setup_overridden_project_settings()
	
	static var override_godot_default_settings: bool = true
	static var footstep_instances: int = 0
	
	const FOOTSTEP_MAX_INSTANCES: int = 16
	const PARTICLES_MAX_INSTANCES: int = 128

	static func setup_overridden_project_settings() -> void:
		if override_godot_default_settings:
			RenderingServer.viewport_set_default_canvas_item_texture_repeat(
				Game.Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_REPEAT_MIRROR)
			RenderingServer.viewport_set_default_canvas_item_texture_filter(
				Game.Application.main_window.get_viewport_rid(), RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST)	
			
			Game.Application.main_window.canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
			Game.Application.main_window.canvas_item_default_texture_repeat = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
			Game.Application.main_window.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	static func set_max_fps(_max_fps: int) -> void:
		Engine.max_fps = _max_fps
class Directory:
	extends GameSubClass
	static func is_path_in_dir(_path: String, _dir: String) -> bool:
		var dir_content = DirAccess.get_directories_at(_dir)
		print(dir_content)
		return _path in dir_content
	static func is_path_in_folder(_path: String) -> bool:
		return false

class GameSubClass:
	static func _setup() -> void: pass
