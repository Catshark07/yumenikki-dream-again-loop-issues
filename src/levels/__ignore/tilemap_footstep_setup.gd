class_name FootstepTileMap
extends TileMapLayer

@export var ground_material: Footstep.mat
@export var custom_sound: AudioStream

func _ready() -> void:
	modulate = Color.TRANSPARENT
