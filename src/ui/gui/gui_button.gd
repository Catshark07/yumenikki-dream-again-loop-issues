@tool

class_name GUIPanelButton
extends GUIPanel

@export_category("Button Properties")

signal pressed
signal on_hover
signal on_unhover

# ---- constants ----
const  button_display_texture_shader: Shader = preload("res://src/shaders/ui/button_texture_grad_mask.gdshader")

@export_group("Button Visuals")
@export var button_panel_override: StyleBoxTexture:
	set(_ov):
		button_panel_override = _ov
		if main_container != null: 
			if _ov: main_container.add_theme_stylebox_override("panel", _ov)
			else: main_container.remove_theme_stylebox_override("panel")
@export var button_display_texture: Texture = CanvasTexture.new()

@export_group("Color Visuals")
const NORMAL_CLR: 	Color = Color(1, 1, 1)
const HOVER_CLR: 	Color = Color(1, 0.0, 0.23)
const DISABLED_CLR: Color = Color(0.35, 0.35, 0.45) 
const PRESSED_CLR: 	Color = Color(1, 1, 0)

@export var normal_colour: 		Color = Color(1, 1, 1)
@export var press_colour: 		Color = Color(1, 1, 0)
@export var hover_colour: 		Color = Color(1, 0.0, 0.23)
@export var disabled_colour: 	Color = Color(0.35, 0.35, 0.45) 
var curr_colour: 				Color = normal_colour

# ---- misc ----
@export var abstract_button: AbstractButton
var modu_tw: Tween
var disp_tw: Tween

func _init(
	_normal_colour: 	Color = NORMAL_CLR,
	_hover_colour: 		Color = HOVER_CLR,
	_disabled_colour: 	Color = DISABLED_CLR,
	_press_colour: 		Color = PRESSED_CLR) -> void:
		normal_colour 	= _normal_colour
		hover_colour 	= _hover_colour
		disabled_colour = _disabled_colour
		press_colour 	= _press_colour
	

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): abstract_button.pressed.emit()
func _children_components_setup() -> void:
	super()
	abstract_button = Utils.get_child_node_or_null(main_container, "abstract_button")
	if 	abstract_button == null:
		abstract_button = Utils.add_child_node(main_container, AbstractButton.new(), "abstract_button")

func _additional_setup() -> void:	
	set_active(true)
	set_panel_modulate(Color.WHITE)
	
	mouse_filter = Control.MOUSE_FILTER_PASS
	focus_mode = Control.FOCUS_ALL
	
	display_bg.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	display_bg.size_flags_vertical = Control.SIZE_FILL
	
	if Engine.is_editor_hint(): set_button_modulate(curr_colour)
	else:						set_button_modulate(normal_colour)

	Utils.connect_to_signal(on_visibility_change, visibility_changed)
	
	Utils.connect_to_signal(on_hover.emit, 		abstract_button.hover_entered)
	Utils.connect_to_signal(on_unhover.emit, 	abstract_button.hover_exited)
	
	Utils.connect_to_signal(_on_press, 		abstract_button.pressed)
	Utils.connect_to_signal(_on_hover, 		abstract_button.hover_entered)
	Utils.connect_to_signal(_on_unhover, 	abstract_button.hover_exited)
	
	Utils.connect_to_signal(_on_focus_enter, 	focus_entered)
	Utils.connect_to_signal(_on_focus_exit, 	focus_exited)
	
	Utils.connect_to_signal(set_button_modulate.bind(normal_colour), 	abstract_button.enabled)
	Utils.connect_to_signal(set_button_modulate.bind(disabled_colour), 	abstract_button.disabled)
	

func on_visibility_change() -> void: 
	unhover_animation()
	set_self_modulate(curr_colour)
	
# --- visual & general behaviour functions ---
func _on_hover() -> void: 
	grab_focus()
func _on_unhover() -> void: 
	release_focus()

func _on_focus_enter() -> void:
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_hover.wav"), .5)
	hover_animation()
	set_button_modulate(hover_colour)
func _on_focus_exit() -> void: 
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_unhover.wav"), .5)
	unhover_animation()
	set_button_modulate(normal_colour)

func _on_press() -> void: 
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_press.wav"))
	press_animation()
	pressed.emit()

# --- animations ---
func hover_animation() -> void:
	if disp_tw != null: disp_tw.kill()
	disp_tw = create_tween()
	
	disp_tw.set_parallel()
	disp_tw.set_ease(Tween.EASE_OUT)
	disp_tw.set_trans(Tween.TRANS_EXPO)
	disp_tw.tween_method(
		resize_display_bg_x, 
		0, 
		main_container.size.x - 5, .35)
		
	disp_tw.tween_property(text_display, "modulate:v", - modulate.v, .35)
	disp_tw.tween_property(icon_display, "modulate:v", - modulate.v, .35)
func unhover_animation() -> void: 
	if disp_tw != null: disp_tw.kill()
	disp_tw = create_tween()
		
	disp_tw.set_parallel()
	disp_tw.set_ease(Tween.EASE_OUT)
	disp_tw.set_trans(Tween.TRANS_EXPO)
	disp_tw.set_ignore_time_scale()
	
	disp_tw.tween_method(
		resize_display_bg_x, 
		display_bg.custom_minimum_size.x, 
		0, .35)
		
	disp_tw.tween_property(text_display, "modulate:v", normal_colour.v, .35)
	disp_tw.tween_property(icon_display, "modulate:v", 1, .35)

func press_animation() -> void:
	modulate = normal_colour
	set_button_modulate(press_colour, Tween.EASE_OUT, Tween.TRANS_LINEAR, .175)

# --- setter functions ---
func set_button_modulate(
	_modu: Color, 
	_ease: Tween.EaseType = Tween.EASE_OUT, 
	_trans: Tween.TransitionType = Tween.TRANS_EXPO,
	dur: float = .2) -> void:		
	curr_colour = _modu
	
	if modu_tw != null: modu_tw.kill()
	
	modu_tw = create_tween()
	modu_tw.set_ease(_ease)
	modu_tw.set_trans(_trans)
	modu_tw.set_parallel()
	modu_tw.set_ignore_time_scale()
	
	modu_tw.tween_method(display_bg.set_self_modulate, 		modulate, _modu, dur)
	modu_tw.tween_method(main_container.set_self_modulate, 	modulate, _modu, dur)
	
		
func set_active(_active: bool) -> void:
	abstract_button.set_active(_active)
func resize_display_bg_x(_new: float) -> void:
	display_bg.custom_minimum_size.x = _new
