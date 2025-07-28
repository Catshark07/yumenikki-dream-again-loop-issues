extends State

@export var pause_menu: Control
@export var pause_bgm: BGM

func enter_state() -> void: 
	Ambience.mute()
	GameManager.set_ui_visibility(false)
	GameManager.show_options(true)
	
	pause_menu.visible = true
	pause_bgm.play_music()
	GameManager.set_cinematic_bars(true)
	Application.pause()

func exit_state() -> void: 
	Ambience.unmute()
	GameManager.show_options(false)

	pause_menu.visible = false
	Music.play_music_dict(Music.prev_music)
	GameManager.set_cinematic_bars(false)
	Application.resume()

func input(event: InputEvent, ) -> void:
	if Input.is_action_just_pressed("ui_esc_menu"):
		if Game.is_paused: GameManager.pause_options(false)
