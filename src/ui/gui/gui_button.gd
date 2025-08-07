@tool

class_name GUIPanelButton
extends GUIPanel

@export_category("Button Properties")

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
var curr_colour = Color.WHITE
@export var normal_colour = Color(1, 1, 1)
@export var hover_colour: Color = Color(1, 0.0, 0.23)
@export var disabled_colour: Color = Color(0.35, 0.35, 0.45) 
@export var press_colour: Color = Color(1, 1, 0)

# ---- misc ----
@export_storage var abstract_button: AbstractButton
var modu_tw: Tween
var disp_tw: Tween

# ---- signals ----
signal pressed
signal toggled(_truth)
signal hover_entered
signal hover_exited

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"): pressed.emit()

func _children_components_setup() -> void:
	super()
	abstract_button = GlobalUtils.get_child_node_or_null(main_container, "abstract_button")
	if abstract_button == null:
		abstract_button = GlobalUtils.add_child_node(main_container, AbstractButton.new(), "abstract_button")
func _additional_setup() -> void:	
	mouse_filter = Control.MOUSE_FILTER_PASS
	set_active(true)
	
	set_panel_modulate(curr_colour)
	
	display_bg.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	display_bg.size_flags_vertical = Control.SIZE_FILL
	
	abstract_button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	abstract_button.focus_mode = Control.FOCUS_NONE
	self.focus_mode = Control.FOCUS_ALL
	
	if Engine.is_editor_hint():
		set_button_modulate(curr_colour)
		
	else:
		GlobalUtils.connect_to_signal(on_visibility_change, visibility_changed)
		
		GlobalUtils.connect_to_signal(pressed.emit, abstract_button.pressed)
		GlobalUtils.connect_to_signal(hover_entered.emit, abstract_button.hover_entered)
		GlobalUtils.connect_to_signal(hover_exited.emit, abstract_button.hover_exited)
		
		GlobalUtils.connect_to_signal(toggled.emit, abstract_button.toggled)
		GlobalUtils.connect_to_signal(set_button_modulate.bind(normal_colour), abstract_button.enabled)
		GlobalUtils.connect_to_signal(set_button_modulate.bind(disabled_colour), abstract_button.disabled)
		
		GlobalUtils.connect_to_signal(_on_press, pressed)
		GlobalUtils.connect_to_signal(_on_hover, hover_entered)
		GlobalUtils.connect_to_signal(_on_unhover, hover_exited)
		
		GlobalUtils.connect_to_signal(_on_focus_enter, focus_entered)
		GlobalUtils.connect_to_signal(_on_focus_exit, focus_exited)
		
		toggled.connect(func(_toggle): 
			if _toggle: _on_toggle()
			else: 		_on_untoggle())

func on_visibility_change() -> void: 
	unhover_animation()
	set_modulate(curr_colour)
	
# --- visual & general behaviour functions ---
func _on_hover() -> void: 
	grab_focus()
func _on_unhover() -> void: 
	if has_focus(): release_focus()

func _on_focus_enter() -> void:
	if !abstract_button.button.disabled:
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_hover.wav"), .5)
		hover_animation()
		set_button_modulate(hover_colour)
func _on_focus_exit() -> void: 
	if !abstract_button.button.disabled:
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_unhover.wav"), .5)
		unhover_animation()
		set_button_modulate(normal_colour)

func _on_press() -> void: 
	if !abstract_button.button.disabled:
		AudioService.play_sound(preload("res://src/audio/ui/ui_button_press.wav"))
		press_animation()
	
func _on_toggle() -> void: 
	abstract_button.button.mouse_entered.disconnect(_on_hover)
	abstract_button.button.mouse_exited.disconnect(_on_unhover)
func _on_untoggle() -> void:
	abstract_button.button.mouse_entered.connect(_on_hover)
	abstract_button.button.mouse_exited.connect(_on_unhover)

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
		
	disp_tw.tween_property(text_display, "modulate:v", 1 - modulate.v, .35)
	disp_tw.tween_property(icon_display, "modulate:v", 1 - modulate.v, .35)
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
		
	disp_tw.tween_property(text_display, "modulate:v", 1, .35)
	disp_tw.tween_property(icon_display, "modulate:v", 1, .35)

func press_animation() -> void:
	set_button_modulate(normal_colour, Tween.EASE_OUT, Tween.TRANS_CUBIC, 2)
	set_button_modulate(press_colour, Tween.EASE_OUT, Tween.TRANS_LINEAR)
func unpress_animation() -> void:
	unhover_animation()
	set_button_modulate(normal_colour)

# --- setter functions ---

func set_button_modulate(
	_modu: Color, 
	_ease: Tween.EaseType = Tween.EASE_OUT, 
	_trans: Tween.TransitionType = Tween.TRANS_EXPO,
	dur: float = 10) -> void:		
	curr_colour = _modu
	
	if modu_tw != null: modu_tw.kill()
	
	modu_tw = create_tween()
	modu_tw.set_ease(_ease)
	modu_tw.set_trans(_trans)
	modu_tw.set_parallel()
	modu_tw.set_ignore_time_scale()
	
	modu_tw.tween_method(set_modulate, modulate, _modu, dur * get_process_delta_time())
		
	modu_tw.finished

func set_active(_active: bool) -> void:
	abstract_button.set_active(_active)

# ---- exclusive ----
func resize_display_bg_x(_new: float) -> void:
	display_bg.custom_minimum_size.x = _new
