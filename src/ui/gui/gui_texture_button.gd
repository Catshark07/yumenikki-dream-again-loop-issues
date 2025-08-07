@tool

class_name GUITextureButton
extends AbstractButton

@export_storage var texture_renderer: SpriteSheetFormatter

@export var unhover_cell: int
@export var hover_cell: int
@export var press_cell: int

func _setup() -> void:
	super()
	texture_renderer = GlobalUtils.get_child_node_or_null(self, "texture_renderer")
	
	if texture_renderer == null:
		texture_renderer = await GlobalUtils.add_child_node(self, SpriteSheetFormatter.new(), "texture_renderer")
		texture_renderer.progress = unhover_cell if GlobalUtils.is_within_exclusive(unhover_cell, 0, 3) else 0
		
	if !Engine.is_editor_hint():
		
		GlobalUtils.connect_to_signal(_on_press, pressed)
		GlobalUtils.connect_to_signal(_on_hover, hover_entered)
		GlobalUtils.connect_to_signal(_on_unhover, hover_exited)
		
		GlobalUtils.connect_to_signal(_on_focus_enter, focus_entered)
		GlobalUtils.connect_to_signal(_on_focus_exit, focus_exited)

func _on_hover() -> void: 
	grab_focus()
	texture_renderer.progress = hover_cell	
func _on_unhover() -> void: 
	if has_focus(): release_focus()
	texture_renderer.progress = unhover_cell
	
func _on_press() -> void: 
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_press.wav"), .5)
	texture_renderer.progress = press_cell

func _on_focus_enter() -> void:	
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_unhover.wav"), .5)
func _on_focus_exit() -> void:
	AudioService.play_sound(preload("res://src/audio/ui/ui_button_hover.wav"), .5)
