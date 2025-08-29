class_name PLHUDManager
extends Control

static var instance

var ui_tween: Tween

@export var indicators: Control
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
	if _control == null: return
	
	if ui_tween != null: ui_tween.kill()
	ui_tween = self.create_tween()
	ui_tween.set_parallel()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	_control.visible = _show	
	
