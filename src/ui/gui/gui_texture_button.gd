@tool

class_name GUITextureButton
extends Control

@export var texture_renderer: SpriteSheetFormatter
@export var button: AbstractButton

@export var unhover_cell: int
@export var hover_cell: int
@export var press_cell: int

func _ready() -> void:
	self.focus_mode = Control.FOCUS_NONE
	
	texture_renderer = Utils.get_child_node_or_null(self, "texture_renderer")
	button 			 = Utils.get_child_node_or_null(self, "button")
	
	if texture_renderer == null:
		texture_renderer = await Utils.add_child_node(self, SpriteSheetFormatter.new(), "texture_renderer")
		texture_renderer.progress = unhover_cell if Utils.is_within_exclusive(unhover_cell, 0, 3) else 0
		
	if button == null:
		button = Utils.add_child_node(self, AbstractButton.new(), "button")
		
	Utils.connect_to_signal(_on_press, button.pressed)
	Utils.connect_to_signal(_on_hover, button.hover_entered)
	Utils.connect_to_signal(_on_unhover, button.hover_exited)
		
func _on_hover() -> void: 
	if !button.is_active(): return
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_hover.wav"), .5)
	texture_renderer.progress = hover_cell	
func _on_unhover() -> void: 
	if !button.is_active(): return
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_unhover.wav"), .5)
	texture_renderer.progress = unhover_cell
	
func _on_press() -> void: 
	if !button.is_active(): return
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_press.wav"), .5)
	texture_renderer.progress = press_cell
