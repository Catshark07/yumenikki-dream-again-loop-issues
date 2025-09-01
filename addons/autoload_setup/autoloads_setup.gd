@tool
class_name Autoloads
extends EditorPlugin

const SCRIPT_REFERENCES: Dictionary[String, String] = {
	"NodeSaveService" 	: "res://src/systems/save/node_save_service.gd",
	"Game" 				: "res://src/game/game.gd",
	"Music" 			: "res://src/autoloads/bgm_player_music.gd",
	"Ambience" 			: "res://src/autoloads/bgm_player_amb.gd",
	"AudioService" 		: "res://src/autoloads/audio_service.gd",
}

static var CLASS_REFERENCES: Dictionary[String, Node] = {
	"NodeSaveService" 	: NodeSaveService,
	"Game" 				: Game,
	"Music" 			: Music,
	"Ambience" 			: Ambience,
	"AudioService" 		: AudioService,
}

func _enter_tree() -> void:
	for i in SCRIPT_REFERENCES: add_autoload_singleton(i, SCRIPT_REFERENCES[i])
func _exit_tree() -> void:
	for i in SCRIPT_REFERENCES.keys(): remove_autoload_singleton(i)
