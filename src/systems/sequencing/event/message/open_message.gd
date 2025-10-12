extends Event

enum type {MESSAGE, DIALOGUE, PROMPT}

@export var message_type: type
@export_multiline var texts: PackedStringArray

@export_group("Overrides.")
@export var sound_override: AudioStream = MessageDisplay.DEFAULT_SOUND
@export var font_override: Font
@export var font_colour_override: Color = Color.WHITE
@export var speed_override: float = 1
@export_subgroup("Panel.")
@export var hide_panel: bool = false
@export var panel_style_override: StyleBoxTexture = MessageDisplay.DEFAULT_PANEL_STYLE

@export_group("Prompt Exclusive")
@export var prompt_options: Dictionary[StringName, Sequence] = {}

# - event implementations
func _execute() -> void: 
	var type_to_display: MessageDisplay
	
	match message_type:
		type.MESSAGE: type_to_display 	= MessageDisplayManager.instance.message_display
		type.DIALOGUE: type_to_display	= MessageDisplayManager.instance.dialogue_display
		type.PROMPT: 
			type_to_display 	= MessageDisplayManager.instance.prompt_display
			(type_to_display as Prompt).set_options(prompt_options)
		
	if hide_panel:  type_to_display.self_modulate.a = 0
	else:			type_to_display.self_modulate.a = 1
	
	MessageDisplayManager.instance.open_message_display(
		type_to_display, 
		texts,
		sound_override,
		speed_override,
		font_colour_override,
		panel_style_override)
		
	if wait_til_finished: await type_to_display.finished
func _validate() -> bool:
	return !texts.is_empty()

# - misc.
