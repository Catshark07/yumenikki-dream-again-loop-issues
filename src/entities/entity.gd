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

func freeze() -> void: process_mode = Node.PROCESS_MODE_DISABLED
func unfreeze() -> void: process_mode = Node.PROCESS_MODE_INHERIT
