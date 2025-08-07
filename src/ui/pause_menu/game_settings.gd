class_name IngameSettings
extends Control

var initial_hidden_stack_arr: Array
var initial_active_stack_arr: Array

var ui_list: List
var active_stack: Stack

@export var page_graphics: 	Control
@export var page_audio: 	Control
@export var page_options: 	Control
@export var page_game: 		Control

var go_back: 			GUIPanelButton

var game_options: 			GUIPanelButton

var options_audio:  	GUIPanelButton
var options_graphics:  	GUIPanelButton

func references_setup() -> void:
	go_back = get_node("menu/container/go_back")
	
	game_options  			= get_node("menu/container/game/options")
	
	options_audio 		= get_node("menu/container/options/audio")
	options_graphics 	= get_node("menu/container/options/graphics")
	
func buttons_setup() -> void:
	game_options.pressed.connect(func(): active_stack.push(page_options))
	options_audio.pressed.connect(func(): active_stack.push(page_audio))
	options_graphics.pressed.connect(func(): active_stack.push(page_graphics))
	go_back.pressed.connect(func(): active_stack.pop())

func _ready() -> void:
	references_setup()
	buttons_setup()

	ui_list = List.new()
	active_stack = Stack.new()
	
	active_stack.pushed.connect(push_page)
	active_stack.popped.connect(pop_page)

	ui_list.add_to_back(page_graphics)
	ui_list.add_to_back(page_audio)
	ui_list.add_to_back(page_options)
	ui_list.add_to_back(page_game)
	
	reset()

func push_page(_page: Control) -> void: 
	for i in ui_list.array: i.visible = false
	_page.visible = true
func pop_page(_page: Control) -> void:
	if active_stack.top: 
		_page.visible = false
		active_stack.top.visible = true
	else:
		GameManager.pause_options(false)
		Config.save_settings_data()
		reset()

func reset() -> void:
	active_stack.push(page_game)
