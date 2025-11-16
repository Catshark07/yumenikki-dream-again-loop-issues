@tool

class_name SpawnPoint
extends Node2D
	
@export_group("Scene Path and Spawn ID.")
@export_file("*.tscn") var scene_path: String
@export var connection_id: String = "default"

@export_group("Flags.")
@export var parent_instead_of_self: Node = self
@export var as_sibling: bool = true
@export var spawn_dir: Vector2 = Vector2(0, 1)

@onready var spawn_texture: Texture2D = load("res://src/systems/components/independent/pl_spawn.png")
	
func _enter_tree() -> void: Utils.u_add_to_group(self, "spawn_points")
func _exit_tree() -> void: 	Utils.u_remove_from_group(self, "spawn_points")
	
func _ready() -> void:		
	self.name = "spawn_point"
	set_process(false)
	if Engine.is_editor_hint(): queue_redraw()
	
func _draw() -> void:
	if Engine.is_editor_hint():
		draw_texture(
			spawn_texture, 
			-spawn_texture.get_size() / 2 - Vector2(0, 8), Color(modulate, 0.5))
