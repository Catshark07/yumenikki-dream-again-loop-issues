@tool

class_name SceneTraversal
extends Node

@export_file("*.tscn") var scene_path: String:
	set(_path): 
		scene_path = _path
		update_spawn_point_scene_path()
@export var connection_id: String = "default":
	set(_id):
		connection_id = _id
		update_spawn_point_connection_id()
		
@export var spawn_point: SpawnPoint

func _ready() -> void:
	self.name = "spawn"
	update_spawn_point_scene_path()
	update_spawn_point_connection_id()

func update_spawn_point_scene_path() -> void:
	if spawn_point == null: return
	spawn_point.scene_path = scene_path
func update_spawn_point_connection_id() -> void:
	if spawn_point == null: return
	spawn_point.connection_id = connection_id
