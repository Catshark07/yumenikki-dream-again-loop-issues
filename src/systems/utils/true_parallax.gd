# link -- https://gist.github.com/nklbdev/5f8b43e2f796331dee063afdca40df3a

## This script adds parallax functionality to any Node2D.
## But be careful, some Node2D descendants may work in a special way
## with the position and global_position properties,
## or have other conflicts with the logic of this script.[br]
##
## [b]How to use[/b]: Add this script to any [Node2D],
## such as [TileMapLayer] or [Sprite2D], or to [Node2D] itself.
## Or move the main sections of the code to your own script.[br]
## After that, this node will have new properties that allow you
## to configure parallax and see it working in the editor just like in the game.[br]
## This should make it easier to arrange objects
## on different layers so that they match each other.
## It will also simplify the setup of infinite tiling and autoscroll.
@tool
extends Node2D
class_name TrueParallax2D

#----------------------------#
# PUBLIC EXPORTED PROPERTIES #
#----------------------------#

## Enables or disables real-time parallax offset in the editor
## following the center of the 2D editor viewport.
@export var scroll_in_editor := false:
	set(value):
		if scroll_in_editor == value: return
		scroll_in_editor = value
		_update_context()
		_update_scroll()

## Integer positioning to prevent jitter between different parallax layers
## when project setting [member ProjectSettings.rendering/2d/snap/snap_2d_transforms_to_pixel] is turned on.
## Jitter appears because different layers moves with different speed by subpixel distances
## but snapping ROUND's it positions instead FLOOR'ing.
## This setting applies flooring on each motion step to prevent rounding errors.
@export var integer_positioning := false:
	set(value):
		if integer_positioning == value: return
		integer_positioning = value
		_update_scroll()

## Scroll scale[br]
## [code]-INF..-1[/code]: moving faster than viewport in opposite direction[br]
## [code]-1[/code]: moving with viewport speed but in opposite direction[br]
## [code]-1..0[/code]: moving slower than viewport in opposite direction[br]
## [code]0[/code]: immobile in parent coordinate system[br]
## [code]0..1[/code]: moving slower than viewport in the same direction[br]
## [code]1[/code]: moving with viewport (looks immobile when all moving)[br]
## [code]1..INF[/code]: moving faster than viewport in the same direction
@export_custom(PROPERTY_HINT_LINK, "suffix:") var scroll_scale := Vector2.ZERO:
	set(value):
		if scroll_scale.is_equal_approx(value): return
		scroll_scale = value
		_update_scroll()

## Repeats the [Texture2D] of each of this node's children and offsets them by this value.
## When scrolling, the node's position loops, giving the illusion of an infinite
## scrolling background if the values are larger than the screen size.
## If an axis is set to [code]0[/code], the [Texture2D] will not be repeated.
@export_custom(PROPERTY_HINT_LINK, "suffix:px") var repeat_size := Vector2.ZERO:
	set(value):
		value = value.maxf(0)
		if repeat_size.is_equal_approx(value): return
		repeat_size = value
		_update_context()
		_update_scroll()

## Overrides the amount of times the texture repeats.
## Each texture copy spreads evenly from the original by [member repeat_size].
## Useful for when zooming out with a camera.
@export var repeat_times := 0:
	set(value):
		value = maxi(value, 0)
		if value == repeat_times: return
		repeat_times = value
		_update_context()
		_update_scroll()

## The [TrueParallax2D] node will add steps of repeat_size to its position
## to compensate for the difference in offsets with the viewport.
@export var simulate_infinite_tiling := false:
	set(value):
		value = maxi(value, 0)
		if value == simulate_infinite_tiling: return
		simulate_infinite_tiling = value
		_update_context()
		_update_scroll()

## Velocity at which the offset scrolls automatically, in pixels per second.
@export var autoscroll := Vector2.ZERO:
	set(value):
		if value.is_equal_approx(autoscroll): return
		autoscroll = value
		_update_context()
		_update_scroll()

## The [TrueParallax2D]'s offset. This property is automatically updated
## if non-zero values ​​are entered in the [member autoscroll] property.[br]
## [i]Note: Values will loop if [member repeat_size]'s members are positive.[/i]
@export var scroll_offset := Vector2.ZERO:
	set(value):
		if value.is_equal_approx(scroll_offset): return
		scroll_offset = value
		_update_scroll()

#----------------#
# PRIVATE FIELDS #
#----------------#

static var _editor := Engine.is_editor_hint()
var _scroll_disabled := true
var _group_name: StringName
var _parent: CanvasItem:
	set(value):
		if value == _parent: return
		_parent = value
		_update_scroll()

var _viewport: Viewport:
	set(value):
		if value == _viewport: return
		if _viewport:
			if _group_name and is_in_group(_group_name):
				remove_from_group(_group_name)
			_group_name = &""
		# Special group name of cameras attached to viewport with specified RID.
		# Yes, this node works like Camera2D and receives _camera_moved calls.
		_viewport = value
		if _viewport:
			_group_name = StringName("__cameras_" + str(_viewport.get_viewport_rid().get_id()))
			add_to_group(_group_name)
		_update_scroll()

#-------------------#
# OVERRIDEN METHODS #
#-------------------#

# Suppress the position property in the inspector
func _validate_property(property: Dictionary) -> void:
	if property.name == &"position":
		property.usage = PROPERTY_USAGE_NONE

func _notification(what: int) -> void: match what:
	NOTIFICATION_INTERNAL_PROCESS:
		_update_scroll(get_process_delta_time())
	NOTIFICATION_PARENTED, NOTIFICATION_UNPARENTED:
		_update_context()
	NOTIFICATION_ENTER_TREE:
		_update_context()
		tree_exiting.connect(_update_context.bind(false), CONNECT_ONE_SHOT)
	NOTIFICATION_READY:
		set_process_internal(true)
		_update_context()
		_update_scroll()

## Undocumented [CanvasItem] method called before every frame to update viewport's cameras positions.
## It is implemented for cameras and parallax layers in С++ engine sources
## and binded to GDScript but not documented.
## Since it called in the same stage as other cameras,
## it updates node position instantly without visible artifacts (shivering).
func _camera_moved(
	_canvas_transform_in_viewport: Transform2D,
	_camera_position_in_viewport: Vector2,
	_viewport_position_in_canvas: Vector2
	) -> void:
	_update_scroll()

#-----------------#
# PRIVATE METHODS #
#-----------------#

func _update_context(inside_tree: bool = true) -> void:
	if inside_tree and not is_inside_tree(): inside_tree = false
	_viewport = get_viewport() if inside_tree else null
	_parent = get_parent() as CanvasItem if inside_tree else null
	_scroll_disabled = not inside_tree or not _viewport or _editor and not scroll_in_editor
	if inside_tree:
		RenderingServer.canvas_set_item_repeat(get_canvas_item(), repeat_size, repeat_times)
		RenderingServer.canvas_item_set_interpolated(get_canvas_item(), false)

func _update_scroll(delta: float = 0.0) -> void:
	if _scroll_disabled or not _viewport: return

	var parent_from_local := get_transform()
	var global_from_local := get_global_transform()
	var local_from_parent := parent_from_local.affine_inverse()

	var base_from_viewport := \
		Transform2D(local_from_parent.x, local_from_parent.y, Vector2.ZERO) * parent_from_local * \
		(_viewport.canvas_transform * _viewport.global_canvas_transform * global_from_local).affine_inverse()

	var global_from_base := global_from_local * local_from_parent * \
		Transform2D(parent_from_local.x, parent_from_local.y, Vector2.ZERO)

	# All calculations are performed in the base space.
	var viewport_center := base_from_viewport * (get_viewport_rect().size * 0.5)
	var new_scroll_offset := scroll_offset + autoscroll * delta
	var scroll := _scale_safe(viewport_center, scroll_scale)
	if simulate_infinite_tiling:
		new_scroll_offset = _posmod_safe(new_scroll_offset, repeat_size)
		var viewport_offset := viewport_center - scroll - new_scroll_offset
		scroll += viewport_offset - _posmod_safe(viewport_offset, repeat_size)

	var new_global_position := global_from_base * (scroll + new_scroll_offset)
	global_position = new_global_position.floor() if integer_positioning else new_global_position
	# to prevent recursion
	set(&"scroll_offset", new_scroll_offset)

#-------#
# UTILS #
#-------#

static func _scale_safe(v: Vector2, sc: Vector2) -> Vector2: return Vector2(
	v.x if is_zero_approx(sc.x) else v.x * sc.x,
	v.y if is_zero_approx(sc.y) else v.y * sc.y)

static func _posmod_safe(v: Vector2, sz: Vector2) -> Vector2: return Vector2(
	v.x if is_zero_approx(sz.x) else fposmod(v.x, sz.x),
	v.y if is_zero_approx(sz.y) else fposmod(v.y, sz.y))
