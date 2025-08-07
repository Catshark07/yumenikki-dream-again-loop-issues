class_name MessageDisplayManager
extends Control

static var instance: MessageDisplayManager

var is_open: bool = false

var active: MessageDisplay
var message_display: MessageDisplay
var prompt_display: MessageDisplay
var dialogue_display: MessageDisplay

var current_index: int = 0
var texts: Array[String]

func _ready() -> void:
	instance = self
	
	message_display = MessageDisplay.new()
	prompt_display = Prompt.new()
	dialogue_display = Dialogue.new()
	
	self.add_child(message_display)
	self.add_child(prompt_display)
	self.add_child(dialogue_display)
	
	message_display.visible = false
	prompt_display.visible = false
	dialogue_display.visible = false

func open_message_display(
	_display: MessageDisplay,
	_texts: Array[String], 
	_sound: AudioStream,
	_speed: int = 1,
	_reset: bool = true, 
	_font_colour: Color = Color.WHITE, 
	_pos: Vector2 = Vector2(Application.viewport_width / 2, Application.viewport_length - 110)) -> void: 
		
		if is_open == true: return
		current_index = 0
		
		is_open = true
		active = _display
		active.visible = true 
		
		texts.clear()
		for t in _texts: texts.append(t)
		
		message_display.open(_pos, _sound, _speed, _font_colour)
		message_display.display_text(_texts[current_index])
		
func close_message_display(_display: MessageDisplay) -> void:
	_display.close()
	is_open = false

func get_current() -> MessageDisplay: 
	return message_display
	
func proceed_current_message_display() -> void:
	if get_current().can_progress:
		print("continue to next line")
		if current_index < texts.size() - 1:
			
			current_index += 1
			message_display.display_text(
				texts[current_index])

		else:
			close_message_display(get_current())
