@tool

class_name MessageDisplayManager
extends Control

static var instance: MessageDisplayManager

var is_open: bool = false

var active: MessageDisplay
@export var message_display: MessageDisplay
@export var prompt_display: MessageDisplay
@export var dialogue_display: MessageDisplay

var current_index: int = 0
var texts: PackedStringArray

func _ready() -> void:
	instance = self
	
	if Engine.is_editor_hint():
		if Utils.get_child_node_or_null(self, "message_display") == null:
			message_display = Utils.add_child_node(self, MessageDisplay.new(), "message_display")
		if Utils.get_child_node_or_null(self, "prompt_display") == null:
			prompt_display 	= Utils.add_child_node(self, Prompt.new(), "prompt_display")
		if Utils.get_child_node_or_null(self, "dialogue_display") == null:
			dialogue_display= Utils.add_child_node(self, Dialogue.new(), "dialogue_display")
	
	if !Engine.is_editor_hint():
		message_display._setup(self)
		prompt_display._setup(self)
		dialogue_display._setup(self)

func open_message_display(
	_display: MessageDisplay,
	_texts: PackedStringArray, 
	_sound: AudioStream,
	_speed: int = 1,
	_font_colour: Color = Color.WHITE,
	_panel_style: StyleBoxTexture = MessageDisplay.DEFAULT_PANEL_STYLE, 
	_pos: Vector2 = Vector2(Application.viewport_width / 2, Application.viewport_length - 110)) -> void: 
		
		if _display != active and active != null: 
			active.close()
		
		if is_open == true: return
		current_index = 0
		
		is_open = true
		active = _display
		active.visible = true 
		
		texts.clear()
		texts = PackedStringArray(_texts)
		
		active.open(_pos, _sound, _speed, _font_colour, _panel_style)
		active.display_text(_texts[current_index])
		
func close_message_display(_display: MessageDisplay) -> void:
	_display.close()
	is_open = false
	active = null

func proceed_current_message_display() -> void:
	if active == null: return
	
	if active.can_progress:
		if current_index < texts.size() - 1: # - if there's more text.
			print("continue to next line")
			
			current_index += 1
			active.display_text(
				texts[current_index])

		else: # - if we are the very end of text.
			close_message_display(active)
