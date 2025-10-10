class_name Dialogue
extends MessageDisplay

var next_button: GUIPanelButton

func _setup(_manager: MessageDisplayManager) -> void:
	super(_manager)
	next_button = Utils.get_child_node_or_null(buttons_container, "next")
	if 	next_button == null: 
		next_button = Utils.add_child_node(buttons_container, GUIPanelButton.new(), "next")
		next_button.visible = false
		next_button.text_display.text = "next."
		next_button.pressed.connect(manager.proceed_current_message_display)
		
func _on_finish() -> void: pass
		
func open(
	_position: Vector2, 
	_sound: AudioStream, 
	_speed: float = 1, 
	_font_colour: Color = Color.WHITE,
	_panel_style: StyleBoxTexture = DEFAULT_PANEL_STYLE) -> void:
	
	if next_button != null: 
		next_button.visible = true
		next_button.grab_focus()
	super(_position, _sound, _speed, _font_colour)
	
func close() -> void: 
	if next_button != null: next_button.visible = false
	super()
