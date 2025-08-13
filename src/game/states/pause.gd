extends State

@export var pause_menu: Control

func _enter_state() -> void: 
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 300)
	GameManager.set_control_visibility(GameManager.player_hud.indicators, false)
	GameManager.set_control_visibility(pause_menu, true)
	GameManager.set_control_visibility(GameManager.options, true)

	GameManager.set_cinematic_bars(true)
	Application.pause()
	Application.main_window.grab_focus()

func _exit_state() -> void: 
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 16000)

	GameManager.set_control_visibility(GameManager.options, false)
	GameManager.set_control_visibility(pause_menu, false)
	
	GameManager.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(false)
