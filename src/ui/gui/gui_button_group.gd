class_name GUIPanelButtonGroup
extends Control

@export var buttons: Array[GUIPanelButton]
var curr_selected: GUIPanelButton

signal idx_pressed(_idx: int)

func _ready() -> void:
	if  buttons.is_empty():
		for b in get_children():
			if !b is GUIPanelButton: continue
			b.pressed.connect(idx_pressed.emit.bind(get_children().find(b)))
			buttons.append(b)
			
	if buttons.is_empty(): return
	if buttons[0] != null:
		curr_selected = buttons[0]
		curr_selected.grab_focus()
