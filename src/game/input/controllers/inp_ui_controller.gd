class_name UIInputController
extends Node

var ui_focus: Control

func _setup() -> void: pass
func _controller_input(_event: InputEvent) -> void: 
	if ui_focus == null: return
	if _event.is_action_pressed("ui_accept"):
		ui_focus.accept_event()
func _update(_delta: float) -> void: pass
