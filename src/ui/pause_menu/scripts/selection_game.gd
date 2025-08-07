extends UIStackNode

@export var quit_to_menu: GUIPanelButton 
@export var quit_to_desktop: GUIPanelButton 

func _ready() -> void:
	super()
	quit_to_menu.pressed.connect(
		func(): 
			GameManager.change_scene_to(preload("res://src/levels/_neutral/menu/menu.tscn"))
			GameManager.pause_options(false)
			GameManager.pause(false)
			)		
	quit_to_desktop.pressed.connect(
		func(): Application.quit())
