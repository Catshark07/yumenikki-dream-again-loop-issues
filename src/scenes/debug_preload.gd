extends SceneNode

# -- 
@export_group("Pre-game Warning Section.")
@export var timer: Timer
@export var preload_control: Control
@export var pregame_control: Control

# -- 
@export_group("Preloading Content Section.")
@export var shader_garbage_placeholder: Node2D

const LOADING_INTERVAL := 0.02

const SHADERS_PATH := "res://src/shaders/"
const SCENES_PATH := "res://src/levels/"

const CACHED_SHADER_FILE_PATH := "cache/cached_shader.txt"
const CACHED_SCENES_FILE_PATH := "cache/cached_scenes.config"

const MAX_SCENES_TO_LOAD := 3

var shaders: PackedStringArray
var scenes: PackedStringArray

var res_cached_shader_file: FileAccess
var res_cached_scenes_file: FileAccess

func _ready() -> void:
	super()
	preload_control.visible = true
	
	timer.autostart = false
	timer.one_shot = true
	timer.wait_time = 15
	
	Utils.connect_to_signal(
		func(): SceneManager.change_scene_to(load(Game.MENU_SCENE)), 
		timer.timeout,
		CONNECT_ONE_SHOT)

func _on_push() -> void:
	super()
	await get_tree().create_timer(.5).timeout
	
	shader_garbage_placeholder.material = ShaderMaterial.new()
	shader_garbage_placeholder.texture 	= preload("res://game_icon.png")
	
	print("CREATING SHADER CACHE FILE")
	var shader_file = FileAccess.open("res://" + CACHED_SHADER_FILE_PATH, FileAccess.WRITE)
	shader_file.store_string("")
	shader_file.close()
	
	if OS.is_debug_build():
		await gather_all_shaders()
	
	await handle_shader_precompile()
	AudioService.play_sound(load("res://src/audio/ui/ui_instructions.WAV"), 0.8)
	EventManager.invoke_event("GAME_PRELOADING_CONTENT_FINISH")
	print("Preloading content finished!")
	
	if !Save.data["game"]["read_warning"]:
		preload_control.visible = false
		timer.start()
	
		Save.data["game"]["read_warning"] 	= true
		Game.finished_preloading_content 	= true
	
	else:
		SceneManager.change_scene_to(load(Game.MENU_SCENE))
	
func compile_shader_material(_shader: Shader) -> void: 
	shader_garbage_placeholder.material.shader = _shader

func gather_all_shaders() -> void:
	res_cached_shader_file = FileAccess.open("res://" + CACHED_SHADER_FILE_PATH, FileAccess.WRITE)
	
	for i in DirAccess.get_directories_at(SHADERS_PATH):
		if (i.ends_with(".gdshader")): 
			shaders.append(SHADERS_PATH + i)
			res_cached_shader_file.store_line(SHADERS_PATH + i)
			continue
			
		for j in DirAccess.get_files_at(SHADERS_PATH + i):
			if (j.ends_with(".gdshader")): 
				shaders.append(SHADERS_PATH + i + "/" + j)
				res_cached_shader_file.store_line(SHADERS_PATH + i + "/" + j)
				
		await get_tree().create_timer(LOADING_INTERVAL).timeout
	
	res_cached_shader_file.close()
	
func gather_all_scenes() -> void:
	res_cached_scenes_file = FileAccess.open("res://" + CACHED_SCENES_FILE_PATH, FileAccess.WRITE)
	for i in DirAccess.get_directories_at(SCENES_PATH):
		if i != "__ignore":
			for j in DirAccess.get_directories_at(SCENES_PATH + i): 
				for s in DirAccess.get_files_at(SCENES_PATH + i + "/" + j):
					var scene_path = SCENES_PATH + i + "/" + j + "/" + s
					if "level.tscn" in s:
						scenes.append(scene_path)
						res_cached_scenes_file.store_line(JSON.stringify(scene_path))

	res_cached_scenes_file.close()

func handle_shader_precompile() -> void:
	res_cached_shader_file = FileAccess.open("res://" + CACHED_SHADER_FILE_PATH, FileAccess.READ)
	var curr_shader_line: String = res_cached_shader_file.get_line()
	
	while !(curr_shader_line.is_empty()):
		var loaded_shader = load(curr_shader_line)
		
		if loaded_shader: 
			compile_shader_material(loaded_shader)
			print("SHADER -- ", curr_shader_line)
			
		curr_shader_line = res_cached_shader_file.get_line()
		await get_tree().create_timer(LOADING_INTERVAL).timeout
		
	
	res_cached_shader_file.close()
