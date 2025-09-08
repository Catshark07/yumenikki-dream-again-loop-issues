@tool

class_name MessageDisplay
extends PanelContainer

# - constants.
const MIN_SIZE := Vector2i(280, 80)
const DEFAULT_PUNCTUATION_WAIT = 0.25
const DEFAULT_LETTER_WAIT = 0.0275
const DEFAULT_SOUND: AudioStreamWAV = preload("res://src/audio/se/se_talk_default.wav")
const DEFAULT_PANEL_STULE := preload("res://src/ui/panel_default.tres")
const SOUND_PER_LETTER := 3

# - internal properties
var initial_position: Vector2
var text: String = ""
var letter_count_to_sound: int = 0

var sound: AudioStream = load("res://src/audio/se/se_talk_default.wav")
var speed: float = 1
var colour: Color = Color.WHITE

var manager: MessageDisplayManager

# - components
var container: MarginContainer
var sub_container: VSplitContainer
var text_container: RichTextLabel
var typewriter_timer: Timer
var buttons_container: Container
var can_progress: bool = false
var animation_tween: Tween

# - signals
signal finished

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
func _setup(_manager: MessageDisplayManager) -> void:
	manager = _manager
	visible = false
	
	self.mouse_filter = Control.MOUSE_FILTER_IGNORE
	self.custom_minimum_size = Vector2(MIN_SIZE.x, MIN_SIZE.y)
	self.name = "message_display"
	self.add_theme_stylebox_override("panel", DEFAULT_PANEL_STULE)
	
	container = MarginContainer.new()
	sub_container = VSplitContainer.new()
	
	typewriter_timer = Timer.new()
	text_container = RichTextLabel.new()
	buttons_container = VBoxContainer.new()
	
	self.add_child(container)
	self.add_child(typewriter_timer)
	
	container.mouse_filter = Control.MOUSE_FILTER_IGNORE	

	container.add_child(sub_container)
	container.add_theme_constant_override("margin_left", 10)
	container.add_theme_constant_override("margin_right", 10)
	container.add_theme_constant_override("margin_top", 10)
	container.add_theme_constant_override("margin_bottom", 10)
	container.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	sub_container.add_child(text_container)
	sub_container.add_child(buttons_container)
	sub_container.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED 
	sub_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	
	buttons_container.add_theme_constant_override("separation", 1)
	buttons_container.set_anchors_preset(PRESET_FULL_RECT)
	buttons_container.custom_minimum_size.y = 24
	buttons_container.alignment = BoxContainer.ALIGNMENT_CENTER
	
	text_container.fit_content = true
	text_container.bbcode_enabled = true
	text_container.clip_contents = false
	text_container.scroll_active = false
	
	sub_container.split_offset = 150
func _on_finish() -> void: 
	typewriter_timer.wait_time = 1.25 + text.length() / 1000
	typewriter_timer.start()
	await typewriter_timer.timeout
	manager.proceed_current_message_display()

func open(
	_position: Vector2,
	_sound: AudioStream,
	_speed: float = 1,
	_font_colour: Color = Color.WHITE) -> void:
		sound = _sound
		speed = _speed if _speed != 1 else speed
		colour = _font_colour 
		
		initial_position = _position
		self.position = initial_position - self.size / 2
		
		__open_animation()
		typewriter_timer.one_shot = true
		typewriter_timer.autostart = false
		text_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
func close() -> void:
	text_container.text = ""
	finished.emit()
	__close_animation()
	
func display_text	(_text: String) -> void:
	await iterate_text(_text)
	_on_finish()
func return_parsed	(_text: String, c: int = 0, j: int = c + 1) -> String: 
	var parsed_string: String
	var in_tag: bool
	j = c + 1
	
	for ps in _text.length():
		c = ps
		
		if _text[c] == "[":
			if _text[j] != "/": 
				in_tag = true
				continue
			elif _text[j] != "]": 
				in_tag = true
				continue
		if _text[c] == "]": 
			in_tag = false
			continue
		if !in_tag: 
			parsed_string += _text[ps]
	return parsed_string ## outside of a tag
func iterate_text	(_text: String) -> void:
			
			can_progress = false
			text_container.modulate = colour
			
			text_container.clear()
			text_container.visible_characters = 0
			
			text = return_parsed(_text)
			text_container.text = _text

			for char in text.length(): 
				text_container.visible_characters += 1

				match text[char]:
					".", "!", "?", ",", ";", ":" : 
						typewriter_timer.wait_time = DEFAULT_PUNCTUATION_WAIT * speed
					_: 	
						typewriter_timer.wait_time = DEFAULT_LETTER_WAIT * speed
				letter_count_to_sound += 1
			
				if letter_count_to_sound > SOUND_PER_LETTER - 1:
					letter_count_to_sound = 0
					AudioService.play_sound(sound, 1, randf_range(0.9, 1.1))
				
				typewriter_timer.start()
				await typewriter_timer.timeout
				
			can_progress = true

# - animations
func __open_animation() -> void: 
	visible = true
	if animation_tween != null: animation_tween.kill()
	animation_tween = self.create_tween()
	
	animation_tween.set_parallel(true)
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.set_trans(Tween.TRANS_EXPO)
	
	position.y += 50
	modulate.a = 0
	
	animation_tween.tween_property(self, "position:y", initial_position.y, 1)
	animation_tween.tween_property(self, "modulate:a", 1, 1)
func __close_animation() -> void: 
	if animation_tween != null: animation_tween.kill()
	animation_tween = self.create_tween()
	
	animation_tween.set_parallel(true)
	animation_tween.set_ease(Tween.EASE_OUT)
	animation_tween.set_trans(Tween.TRANS_EXPO)
	
	animation_tween.tween_property(self, "position:y", position.y + 50, 1)
	animation_tween.tween_property(self, "modulate:a", 0, 1)
	
	await  animation_tween.finished
	visible = false
	
