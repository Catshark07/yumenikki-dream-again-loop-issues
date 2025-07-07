class_name InputManager
extends Node

static var vector_input: Vector2
var scheme: Keybind

func _ready() -> void:
	scheme = Keybind.new()
	
	for i in (scheme.bind): 
		if !InputMap.has_action(i): InputMap.add_action(i)
		for k in scheme.bind[i]: InputMap.action_add_event(i, k)
		
func _process(_delta: float) -> void: 
	vector_input = Vector2(
		int(Input.is_action_pressed("move_right")) - int(Input.is_action_pressed("move_left")),
		int(Input.is_action_pressed("move_down")) - int(Input.is_action_pressed("move_up"))
		)
		
func key_command(_key_id: String) -> void:
	if Input.is_action_pressed(_key_id) and _key_id in scheme.bind:
		scheme.bind[_key_id]["command"]

class InputAction:
	extends InputEventKey
	var command: Command
	
	func _init(_key: Key, _command: Command = null) -> void: 
		keycode = _key
		command = _command
	
class Keybind:
	extends Object
	
	var bind: Dictionary = {
		"esc_menu" 			: [ InputAction.new(KEY_ESCAPE) ],
		"hud_toggle" 		: [ InputAction.new(KEY_TAB) ],
		
		"sprint" 			: [ InputAction.new(KEY_SHIFT) ],
		"sneak" 			: [ InputAction.new(KEY_CTRL) ],
		
		"move_up" 			: [ InputAction.new(KEY_UP), InputAction.new(KEY_W) ],
		"move_down" 		: [ InputAction.new(KEY_DOWN), InputAction.new(KEY_S) ],
		"move_right" 		: [ InputAction.new(KEY_RIGHT), InputAction.new(KEY_D) ],
		"move_left" 		: [ InputAction.new(KEY_LEFT), InputAction.new(KEY_A) ],
		
		"ui_up" 			: [ InputAction.new(KEY_UP), InputAction.new(KEY_W) ],
		"ui_down" 			: [ InputAction.new(KEY_DOWN), InputAction.new(KEY_S) ],
		"ui_right" 			: [ InputAction.new(KEY_RIGHT), InputAction.new(KEY_D) ],
		"ui_left" 			: [ InputAction.new(KEY_LEFT), InputAction.new(KEY_A) ],
		
		"ui_accept" 		: [ InputAction.new(KEY_Z)],
		"ui_cancel" 		: [ InputAction.new(KEY_X)],
		
		"pinch" 			: [InputAction.new(KEY_Q)],
		"interact" 			: [InputAction.new(KEY_E)],
		"emote" 			: [InputAction.new(KEY_G)],
		"primary_action"	: [InputAction.new(KEY_Z)],
		"secondary_action" 	: [InputAction.new(KEY_X)],
		
		"inventory" 		: [InputAction.new(KEY_ALT)],
		"favourite_effect" 	: [InputAction.new(KEY_F)],
		}
