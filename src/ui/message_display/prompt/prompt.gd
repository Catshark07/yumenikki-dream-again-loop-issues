class_name Prompt
extends MessageDisplay

@export var option_buttons: Array = []

func set_options(_opts: Dictionary[StringName, Sequence]) -> void:
	for option in _opts:
		var option_button: GUIPanelButton = Utils.add_child_node(buttons_container, GUIPanelButton.new(), option)
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
	
	super(_position, _sound, _speed, _font_colour)
