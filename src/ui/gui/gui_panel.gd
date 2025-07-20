# ---- 	CUSTOM PANEL HIERARCHY 	----
# -> Control
# 	-> Main Container
# 		-> Display BG
#		-> Margin Container
#			-> Icon Content Seperator
#				-> Icon Display Container
#				-> Icon Display
#				-> Inner Main Container
#					-> Text Display
# ----							----

@tool

class_name GUIPanel
extends Control

@export_category("Panel Properties")

var resize_tweener: Tween

# ---- constants ----

var icon: Texture:
	get:
		icon_display_container.visible = (icon_display.texture != null)
		return icon_display.texture

const DEFAULT_PANEL_DISPLAY_SHADER: Shader = preload("res://src/shaders/ui/button_texture_grad_mask.gdshader")
const DEFAULT_DISPLAY_BG_COLOR = Color(0,0,0,1)
var DEFAULT_PANEL_DISPLAY_TEXTURE := CanvasTexture.new()

# ---- size control ----
# ---- common vars ----
@export_group("Panel Visuals")
@export var panel_stylebox_override: StyleBoxTexture:
	set(_ov):
		panel_stylebox_override = _ov
		if main_container != null: 
			if _ov: main_container.add_theme_stylebox_override("panel", _ov)
			else: main_container.remove_theme_stylebox_override("panel")
@export var panel_display_texture: Texture2D = DEFAULT_PANEL_DISPLAY_TEXTURE
@export var panel_display_colour: Color = DEFAULT_DISPLAY_BG_COLOR
@export var panel_display_shader: Shader = DEFAULT_PANEL_DISPLAY_SHADER:
	set(_shader):
		panel_display_shader = _shader
		if Engine.is_editor_hint():set_panel_texture_display_shader(panel_display_shader)

# ---- inner button components ---- 
@export_storage var display_bg: TextureRect

@export_storage var main_container: PanelContainer
@export_storage var inner_main_container: CenterContainer
@export_storage var icon_content_seperator: BoxContainer

@export_storage var margin_container: MarginContainer
@export_storage var icon_display_container: CenterContainer
@export_storage var icon_display: TextureRect

@export_storage var text_display: Label

func _children_components_setup() -> void:
	main_container = GlobalUtils.get_child_node_or_null(self, "main_container")
	
	display_bg = GlobalUtils.get_child_node_or_null(self.main_container, "display_bg")
	margin_container = GlobalUtils.get_child_node_or_null(self.main_container, "margin_container")
	
	icon_content_seperator = GlobalUtils.get_child_node_or_null(self.margin_container, "icon_content_seperator")
	
	icon_display_container = GlobalUtils.get_child_node_or_null(self.icon_content_seperator, "icon_display_container")
	inner_main_container = GlobalUtils.get_child_node_or_null(self.icon_content_seperator, "inner_main_container")
	
	icon_display = GlobalUtils.get_child_node_or_null(self.icon_display_container, "icon_display")
	text_display = GlobalUtils.get_child_node_or_null(self.inner_main_container, "text_display")
	
	# --- 
	
	if main_container == null: main_container = GlobalUtils.add_child_node(self, PanelContainer.new(), "main_container")
	
	if display_bg == null: display_bg = GlobalUtils.add_child_node(self.main_container, TextureRect.new(), "display_bg")
	if margin_container == null: margin_container = GlobalUtils.add_child_node(self.main_container, MarginContainer.new(), "margin_container")
	
	if icon_content_seperator == null: icon_content_seperator = GlobalUtils.add_child_node(self.margin_container, HBoxContainer.new(), "icon_content_seperator")
	
	if icon_display_container == null: icon_display_container = GlobalUtils.add_child_node(self.icon_content_seperator, CenterContainer.new(), "icon_display_container")
	if inner_main_container == null: inner_main_container = GlobalUtils.add_child_node(self.icon_content_seperator, CenterContainer.new(), "inner_main_container")
	
	if icon_display == null: icon_display = GlobalUtils.add_child_node(self.icon_display_container, TextureRect.new(), "icon_display")
	if text_display == null: text_display = GlobalUtils.add_child_node(self.inner_main_container, Label.new(), "text_display")

func _ready() -> void:
	_children_components_setup()
	_core_setup()
	_additional_setup()

static func _create() -> GUIPanel:
	return GUIPanel.new()
	
func _additional_setup() -> void: pass
func _core_setup() -> void:
	main_container.size = size
	main_container.set_anchors_preset.call_deferred(Control.PRESET_FULL_RECT)
		
	text_display.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	text_display.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	text_display.label_settings = preload("res://src/global_label_settings.tres")
	
	icon_display_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	icon_content_seperator.mouse_filter = Control.MOUSE_FILTER_IGNORE
	inner_main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	main_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	display_bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
	display_bg.stretch_mode = TextureRect.STRETCH_SCALE
	display_bg.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	
	icon_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	text_display.mouse_filter = Control.MOUSE_FILTER_IGNORE
	margin_container.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	margin_container.add_theme_constant_override("margin_top", 2)
	margin_container.add_theme_constant_override("margin_bottom", 2)
	margin_container.add_theme_constant_override("margin_right", 4)
	margin_container.add_theme_constant_override("margin_left", 4)
	
	display_bg.texture = CanvasTexture.new()
	display_bg.size_flags_horizontal = true
	display_bg.size.y = main_container.size.x
	display_bg.size.y = main_container.size.y
		
	set_panel_texture_display_shader(panel_display_shader)
	if theme == null: theme = preload("res://src/code_theme.tres")
	set_panel_modulate(panel_display_colour)
	
# --- setter functions ---	
func set_panel_texture_display_shader(_shader: Shader) -> void:
	if display_bg.material == null: display_bg.material = ShaderMaterial.new()
	display_bg.material.shader = _shader

func set_panel_modulate(_modu: Color) -> void:
	display_bg.modulate = _modu


# --- transform functions --

func resize_panel(new_size: Vector2) -> void: 
	display_bg.size = new_size
