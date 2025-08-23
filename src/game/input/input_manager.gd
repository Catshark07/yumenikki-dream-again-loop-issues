class_name InputManager
extends Game.GameSubClass

# - WASD and Arrow Keys are going to be represented ina VECTOR 4.
# Vector4(S | DOWN_ARROW, D | RIGHT_ARROW, W | UP_ARROW, A | LEFT_ARROW )
static var sb_input_controller	: SBInputController
static var def_input_controller	: UIInputController
static var curr_controller		: InputController

static var keybind: Keybind

static var dir_input				: Vector2i
static var direction_vector_4		: Vector4i

static func _setup() -> void:
	keybind = Keybind.new()
	sb_input_controller = SBInputController.new()
	def_input_controller = UIInputController.new()
	
static func request_curr_controller_change(_controller: InputController) -> void: 
	curr_controller = _controller
	
static func _update(_delta: float) -> void:
	
	direction_vector_4 = Vector4i(
		int(Input.is_action_pressed("pl_move_right")) | int(Input.is_action_pressed("ui_right")),
		int(Input.is_action_pressed("pl_move_down")) | int(Input.is_action_pressed("ui_down")),
		int(Input.is_action_pressed("pl_move_left")) | int(Input.is_action_pressed("ui_left")),
		int(Input.is_action_pressed("pl_move_up")) | int(Input.is_action_pressed("ui_up"))
		)
	
	dir_input = Vector2i(
		direction_vector_4.x - direction_vector_4.z,
		direction_vector_4.y - direction_vector_4.w)

	if curr_controller != null: 
		curr_controller.dir_input = dir_input
		curr_controller._update(_delta)
		
	
static func _input_pass(_event: InputEvent) -> void: 
	if curr_controller != null: 
		curr_controller._handled_input(_event)
static func _unhandled_input_pass(_event: InputEvent) -> void:
	if curr_controller != null: 
		curr_controller._unhandled_input(_event)
	
# definitions:
#	KEYBIND: 
#				keybind defines all the controls and the actions they accept.
#				these actions are ID'd by a string.
#			 	for example: ACTION = "walk_right" : ALLOWED_INPUT = [KEY_D, RIGHT_ARROW]
#			 	IMPORTANT: you need to define all possibile actions. the idea is to allow 
#				the player to change the controls to their liking, and not actions

#	SCHEME: 
#				defines what the current input should do given the current scheme.
#				a scheme contains the action ID's and the commands to-be-executed whenever
#				an action has been triggered (press, screen touch, etc.)
#				for example: 
#					SCHEME_PLAYER:
#						-> walk_right 		: PLAYER_WALK_RIGHT_COMMAND 
#						-> primary_action 	: PLAYER_INTERACT_COMMAND

#					SCHEME_UI:
#						-> primary_action 	: UI_ACCEPT 
#						-> secondary_action : UI_CANCEL 

# 				IMPORTANT!: 
# 					commands are instantiated in the schemes, NOT the objects that they're for.
# 					schemes should hold references to key binds.



class Keybind:
	extends RefCounted
	var bind: Dictionary = {
		# -- miscallenous
		"ui_esc_menu" 		: [ KEY_ESCAPE ],
		"ui_hud_toggle" 	: [ KEY_TAB ],
		"ui_favourite_effect" : [ KEY_F , MOUSE_BUTTON_RIGHT],
		
		# -- UI
		"ui_up" 			: [ KEY_UP, KEY_W ],
		"ui_down" 			: [ KEY_DOWN, KEY_S ],
		"ui_right" 			: [ KEY_RIGHT, KEY_D ],
		"ui_left" 			: [ KEY_LEFT, KEY_A ],
		
		"ui_accept" 		: [ KEY_Z, KEY_ENTER ],
		"ui_cancel" 		: [ KEY_X, KEY_BACKSPACE, KEY_ESCAPE ],
		
		# -- player
		"pl_move_up" 		: [ KEY_UP, KEY_W ],
		"pl_move_down" 		: [ KEY_DOWN, KEY_S ],
		"pl_move_right" 	: [ KEY_RIGHT, KEY_D ],
		"pl_move_left" 		: [ KEY_LEFT, KEY_A ],
		
		"pl_sprint" 		: [ KEY_SHIFT ],
		"pl_sneak" 			: [ KEY_CTRL ],

		"pl_pinch" 			: [ KEY_Q ],
		"pl_interact" 		: [ KEY_E ],
		"pl_emote" 			: [ KEY_G ],
		
		"pl_primary_action"		: [ KEY_Z ],
		"pl_secondary_action" 	: [ KEY_X ],
		
		"pl_inventory" 		: [ KEY_ALT ],
		}
	
	func _init() -> void:
		for action in bind:
			
			if !InputMap.has_action(action):  	
				InputMap.add_action(action)
				
			for key in bind[action]:
				var event_key := InputEventKey.new()
				event_key.keycode = key
				InputMap.action_add_event(action, event_key)
	
	func has_action(_action: String) -> bool: 
		return _action in bind
		
	func get_action_keys(_action: String) -> Array:
		if has_action(_action): return bind[_action]
		return []
		
