@tool

class_name AreaRegion
extends Area2D

@export var rect: CollisionShape2D
@export var debug_colour: Color = Color(0, 0, 0, .3):
	set(_colour):
		if Engine.is_editor_hint():
			debug_colour = _colour
			if rect: rect.debug_color = _colour

var region_priority: int = 0
var shape: Shape2D:
	get: return rect.shape

signal player_enter_handle(_pl: Player)
signal player_exit_handle(_pl: Player)

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	
	set_collision_layer_value(1, false)
	set_collision_mask_value(1, false)

	rect = Utils.get_child_node_or_null(self, "rect")
	
	if rect == null: 
		rect = await Utils.add_child_node(self, CollisionShape2D.new(), "rect")
		rect.shape = RectangleShape2D.new()
		rect.shape.size = Vector2(16, 16)	
		rect.debug_color = Color(0.2 ,0, 0.7, 0.2)
		
	Utils.connect_to_signal(handle_player_enter, self.area_entered)
	Utils.connect_to_signal(handle_player_exit, self.area_exited)
	Utils.connect_to_signal(__disable_collision_if_invisible, self.visibility_changed)
	
	process_mode = Node.PROCESS_MODE_INHERIT
	_setup()

func __disable_collision_if_invisible() -> void:
	print(self, "IT CHANGED??")
	rect.disabled = !(self.visible and is_visible_in_tree())

func _setup() -> void: pass
func _handle_player_enter() -> void: pass
func _handle_player_exit() -> void: pass

func handle_player_enter(_pl: Area2D) -> void:
	if _pl.get_parent() != null and _pl.get_parent() is Player: 
		print(self, "::   enter - ", _pl)
		_handle_player_enter()
		player_enter_handle.emit(Player.Instance.get_pl())
func handle_player_exit(_pl: Area2D) -> void:
	if _pl.get_parent() != null and _pl.get_parent() is Player:
		print(self, "::   exit - ", _pl)
		_handle_player_exit()
		player_exit_handle.emit(Player.Instance.get_pl())
