extends Node

@export var quit_to_menu: GUIPanelButton 
@export var quit_to_desktop: GUIPanelButton 
@export var resume: GUIPanelButton 

func _ready() -> void:
	quit_to_menu.pressed.connect(
		func(): 
			GameManager.change_scene_to(preload("res://src/levels/_neutral/menu/menu.tscn"))
			GameManager.pause_options(false)
			GameManager.pause(false)
			)		
	quit_to_desktop.pressed.connect(
		func(): Application.quit())
	resume.pressed.connect(
		func(): 
			Config.save_settings_data()
			GameManager.pause_options(false))
			
