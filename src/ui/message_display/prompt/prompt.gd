class_name Prompt
extends MessageDisplay

@export var option_buttons: Array = []

func set_options(
	_opts: Dictionary[StringName, Sequence],
	_normal_colour: 	Color = Color(1, 1, 1),
	_hover_colour: 		Color = Color(1, 0.0, 0.23),
	_disabled_colour: 	Color = Color(0.35, 0.35, 0.45) ,
	_press_colour: 		Color = Color(1, 1, 0)) -> void:
		
	for option in _opts:
		var option_button: GUIPanelButton = Utils.add_child_node(
			buttons_container, 
			GUIPanelButton.new(
				_normal_colour, _hover_colour, _disabled_colour, _press_colour
			), 
			option)
			
		var sequence = _opts[option]
		
		option_button.text_display.text = option
		option_buttons.append(option_button)
		sequence.request_ready()
		
		Utils.connect_to_signal(
			func(): 
				manager.proceed_current_message_display()
				SequencerManager.invoke(sequence),
				option_button.pressed, 
				CONNECT_ONE_SHOT)
		
func _on_finish() -> void: pass
		
func close() -> void:
	for i in option_buttons:
		i.queue_free()
		
	option_buttons.clear()
	text_container.text = ""
	finished.emit()
	__close_animation()

		
func open(
	_position: Vector2, 
	_sound: AudioStream, 
	_speed: float = 1, 
	_font_colour: Color = Color.WHITE,
	_panel_style: StyleBoxTexture = DEFAULT_PANEL_STYLE) -> void:
	
	if 	option_buttons.size() > 0: 
		option_buttons[0].grab_focus()
	
	super(_position, _sound, _speed, _font_colour, _panel_style)
