@tool
class_name Autoloads
extends EditorPlugin

const SCRIPT_REFERENCES: Dictionary[String, String] = {
	"Utils" 			: "res://src/systems/utils/utils.gd",
	"Game" 				: "res://src/game/game.gd",
	"SceneManager" 		: "res://src/autoloads/scene_manager.gd",
	"Music" 			: "res://src/autoloads/bgm_player_music.gd",
	"Ambience" 			: "res://src/autoloads/bgm_player_amb.gd",
	"AudioService" 		: "res://src/autoloads/audio_service.gd",
	"NodeSaveService" 	: "res://src/systems/save/node_save_service.gd",
}

func _enter_tree() -> void:
	for i in SCRIPT_REFERENCES: add_autoload_singleton(i, SCRIPT_REFERENCES[i])
func _exit_tree() -> void:
	for i in SCRIPT_REFERENCES.keys(): remove_autoload_singleton(i)
