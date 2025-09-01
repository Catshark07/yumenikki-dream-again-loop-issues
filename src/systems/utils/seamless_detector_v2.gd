@tool

class_name SeamlessDetectorV2
extends Node2D

var loop_record  := {
	bound_side.UP: 0,
	bound_side.DOWN: 0,
	bound_side.RIGHT: 0,
	bound_side.LEFT: 0}
var sentients_to_be_looped := {
	bound_side.UP : [],
	bound_side.DOWN : [],
	bound_side.RIGHT : [],
	bound_side.LEFT : []}

@export_category("Tools.")
@export_tool_button("Setup Loop Objects.") var setup_objs = setup_loop_objects

const screen_size := Vector2i(480, 270)

@export_category("Loop Region.")
@export var tile_size: Vector2i = Vector2i(16, 16)
@export var expansion: Vector2i:
	set(exp): expansion = exp.abs()

@export_group("Values [READ-ONLY].")
@export var bound_size: Vector2i:
	get:
		return (min_bound_size_multiplier * tile_size) + (expansion * tile_size)
@export var min_bound_size_multiplier: Vector2i:
	get: return Vector2(screen_size / (tile_size))
@export var min_bound_size: Vector2i:
	get: return round(min_bound_size_multiplier * tile_size)

enum bound_side {UP, DOWN, RIGHT, LEFT}
enum loop {LOOP, DISABLED}

# ---- collision components ----
@export_group("Collision Components.")
@export_group("Collision Components./Static Bodies.")
@export var up_collision: StaticBody2D 
@export var down_collision: StaticBody2D 
@export var right_collision: StaticBody2D 
@export var left_collision: StaticBody2D 

@export_group("Collision Components./Collision Shapes.")
@export var up_bound: CollisionShape2D
@export var down_bound: CollisionShape2D
@export var right_bound: CollisionShape2D
@export var left_bound: CollisionShape2D

# ---- bound flags ----
@export var loop_region: AreaRegion
@export var renders_setup: bool = false

@export_group("Collision Components./Active Collisions.")
@export var up_active: bool = true: 
	set(_active): 
		up_active = _active
		set_border_active(up_bound, _active)
@export var down_active: bool = true:
	set(_active): 
		down_active = _active
		set_border_active(down_bound, _active)
@export var right_active: bool = true:
	set(_active): 
		right_active = _active
		set_border_active(right_bound, _active)
@export var left_active: bool = true:
	set(_active): 
		left_active = _active
		set_border_active(left_bound, _active)

var v_size: Vector2
var h_size: Vector2

func _ready() -> void: 
	if !Engine.is_editor_hint(): 
		resize(bound_size)
		queue_redraw()
		set_process(false)
func _process(delta: float) -> void:
	if Engine.is_editor_hint(): 
		resize(bound_size)

func resize(new_size: Vector2) -> void:
	
	(up_bound.shape as RectangleShape2D).size.x = new_size.x
	(up_bound.shape as RectangleShape2D).size.y = tile_size.y
	
	(down_bound.shape as RectangleShape2D).size.x = new_size.x
	(down_bound.shape as RectangleShape2D).size.y = tile_size.y
	
	(left_bound.shape as RectangleShape2D).size.x = tile_size.x
	(left_bound.shape as RectangleShape2D).size.y = new_size.y
	
	(right_bound.shape as RectangleShape2D).size.x = tile_size.x
	(right_bound.shape as RectangleShape2D).size.y = new_size.y
	
	up_collision	.position 	= Vector2(0, bound_size.y / 2 + (up_bound.shape as RectangleShape2D).size.y / 2)
	down_collision	.position 	= Vector2(0, -(bound_size.y / 2 + (up_bound.shape as RectangleShape2D).size.y / 2))
	right_collision	.position 	= Vector2(bound_size.x / 2 + (right_bound.shape as RectangleShape2D).size.x / 2, 0)
	left_collision	.position 	= Vector2(-(bound_size.x / 2 + (left_bound.shape as RectangleShape2D).size.x), 0)
	
	(loop_region.rect.shape as RectangleShape2D).size = new_size
	loop_region.rect.position = Vector2.ZERO
	
func set_all_borders_active(_active: bool = true) -> void: 
	up_active 	= _active
	down_active = _active
	right_active = _active
	left_active = _active
func set_border_active(_border: CollisionShape2D, _active: bool = true) -> void:
	if _border == null: return
	_border.disabled = !_active

# - loop renders.
func setup_loop_objects() -> void:
	if renders_setup: return
	renders_setup = true
	
	var renders = get_node_or_null("loop_renders")

func _validate_property(property: Dictionary) -> void:
	var props_to_read_only: PackedStringArray = ["bound_size", "min_bound_size", "min_bound_size_multiplier"]
	if property.name in props_to_read_only:
		property.usage = PROPERTY_USAGE_READ_ONLY | PROPERTY_USAGE_EDITOR
