class_name Save
extends Game.GameSubClass

static var time_elapsed: float
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
	time_elapsed = 0
	if !DirAccess.dir_exists_absolute(SAVE_DIR): 
		DirAccess.make_dir_absolute(SAVE_DIR)

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

static func get_play_time() -> Dictionary:
	return {
		"hours" 	: floori(fmod(time_elapsed / 3600, 24)),
		"minutes" 	: floori(fmod(time_elapsed, 3600) / 60),
		"seconds" 	: floori(fmod(fmod(time_elapsed, 3600), 60))
	}
