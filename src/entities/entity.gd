class_name Entity
extends Node2D

enum compass_headings {
	NORTH = 0,
	NORTH_HORIZ = 1,
	
	HORIZ = 2,
	
	SOUTH_HORIZ = 3,
	SOUTH = 4}
var heading: compass_headings
var direction: Vector2 = Vector2(0, 1):
	set(dir): direction = clamp(dir, Vector2(-1, -1), Vector2(1, 1))
var height: float = 0

func _ready() -> void: pass
func set_active(_active: bool) -> void:
	self.set_process(_active)
	self.set_physics_process(_active)
	self.set_process_input(_active)	

# -------------------------------------------------------------------
# --------------------------SENTIENT ENTITY--------------------------
# -------------------------------------------------------------------
