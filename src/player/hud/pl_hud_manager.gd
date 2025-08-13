class_name PLHUD
extends Control

static var instance

@export var indicators: Control
var ui_tween: Tween

@export var save_icon: TextureRect
@export var save_icon_timer: Timer

# ---- listeners ----

@export var events: Node

func _ready() -> void:
	instance = self
func _setup() -> void:
	events._setup()
	
func add_ui(_control: Control) -> void: 
	if _control.get_parent() != null: 	_control.reparent(self)
	else:								self.add_child(_control)
func remove_ui(_control: Control) -> void: 
	if _control in get_children(): _control.queue_free()	

func show_ui(_control: Control, _show: bool) -> void:	
	if ui_tween != null: ui_tween.kill()
	ui_tween = _control.create_tween()
	ui_tween.set_parallel()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	match _show:
		true: 	ui_tween.tween_property(_control, "modulate:a", 1, .5)
		false: 	ui_tween.tween_property(_control, "modulate:a", 0, .5)
	
