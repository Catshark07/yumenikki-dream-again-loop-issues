class_name Directory
extends Game.GameSubClass

static func is_path_in_dir(_path: String, _dir: String) -> bool:
	var dir_content = DirAccess.get_directories_at(_dir)
	print(dir_content)
	return _path in dir_content
static func is_path_in_folder(_path: String) -> bool:
	return false
