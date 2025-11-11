extends State

@export var pause_menu: Control
@export var hud: Control

func _state_enter() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Audio.adjust_bus_effect(Audio.BUS_DISTORTED, 1, "cutoff_hz", 300)
	
	GameManager.set_cinematic_bars(true)
	GameManager.player_hud.indicators.visible = false
	GameManager.options.visible = true
	pause_menu	.visible = true
	hud			.visible = false

	Application.pause()
	Application.main_window.grab_focus()

func _state_exit() -> void: 
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	Audio.adjust_bus_effect(Audio.BUS_DISTORTED, 1, "cutoff_hz", 16000)

	GameManager.options.visible = false
	pause_menu	.visible = false
	hud			.visible = true
	
	GameManager.set_cinematic_bars(false)
	Application.resume()
	Application.main_window.gui_release_focus()

func _state_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"):
		GameManager.pause_options(false)
