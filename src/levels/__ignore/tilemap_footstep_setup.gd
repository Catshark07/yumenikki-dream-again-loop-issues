class_name FootstepTileMap
extends TileMapLayer

@export var ground_material: FootstepSet = preload("res://src/audio/footsteps/null.tres")

func _ready() -> void: modulate = Color.TRANSPARENT
func get_footstep_material() -> FootstepSet: return ground_material
