extends State

@export var pause_menu: Control

func _enter_state() -> void: 
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 300)
	
	GameManager.set_cinematic_bars(true)
	GameManager.player_hud.indicators.visible = false
	GameManager.options.visible = true
	pause_menu.visible = true

	Application.pause()
	Application.main_window.grab_focus()

func _exit_state() -> void: 
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 16000)

	GameManager.options.visible = false
	pause_menu.visible = false
	
	GameManager.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(false)
