extends Node

var hud_fade: EventListener
var game_save: EventListener

@export var hud: PLHUD
@export var icon: TextureRect
@export var icon_timer: Timer

func _setup() -> void:
	hud_fade = EventListener.new(["SCENE_CHANGE_REQUEST", "SCENE_CHANGE_SUCCESS"], false, self)
	hud_fade.do_on_notify(["SCENE_CHANGE_REQUEST",], func(): hud.show_ui(hud, false))
	hud_fade.do_on_notify(["SCENE_CHANGE_SUCCESS"], func(): hud.show_ui(hud, true))
	
	game_save = EventListener.new(["GAME_FILE_SAVE", "GAME_CONFIG_SAVE"], false, self)
	game_save.do_on_notify(
		["GAME_CONFIG_SAVE"],
		func(): 
			icon.texture = preload("res://src/images/config_save.png")
			hud.show_ui(icon, true)
			icon_timer.wait_time = 1
			icon_timer.start()
			await icon_timer.timeout
			hud.show_ui(icon, false)
			)	
	game_save.do_on_notify(
		['GAME_FILE_SAVE'],
		func(): 
			icon.texture = preload("res://src/images/save.png")
			hud.show_ui(icon, true)
			icon_timer.wait_time = 1
			icon_timer.start()
			await icon_timer.timeout
			hud.show_ui(icon, false)
			)
	
