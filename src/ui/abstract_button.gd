@tool

class_name AbstractButton
extends Control

@export_group("Unique Data")
@export var unique_data: Resource = null:
	set(_data):
		if _data == null: return
		unique_data = _data
		unique_data_changed.emit(_data)
		
# ---- signals ----
signal pressed
signal toggled(_is_toggled)

signal hover_entered
signal hover_exited

signal disabled
signal enabled

signal unique_data_changed(_new_data: Resource)

@export var button: BaseButton # pretty much needed.
var is_toggled: bool = false

# ---- initialisation ----
func _ready() -> void:
	_setup()
	
	self.mouse_filter 	= Control.MOUSE_FILTER_PASS
	self.focus_mode 	= Control.FOCUS_NONE
	self.set_anchors_preset(PRESET_FULL_RECT)
	
	var control_parent = get_parent()
	if control_parent != null and control_parent is Control: self.set_size.call_deferred(control_parent.size)
	
	button.focus_mode 	= Control.FOCUS_CLICK
	button.mouse_filter = Control.MOUSE_FILTER_STOP
	button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	button.set_anchors_preset(PRESET_FULL_RECT)
	
	Utils.connect_to_signal(pressed.emit, 			button.pressed)
	Utils.connect_to_signal(hover_entered.emit, 	button.mouse_entered)
	Utils.connect_to_signal(hover_exited.emit, 		button.mouse_exited)
	Utils.connect_to_signal(toggled.emit, 			button.toggled)
		
func _setup() -> void:
	button = Utils.get_child_node_or_null(self, "button")
	if button == null: 
	
		button = Utils.add_child_node(self, BaseButton.new(), "button")
		button.size = self.size

# - helper
func is_active() -> bool:
	return !button.disabled
func set_active(_active: bool) -> void:
	if button != null: 
		button.disabled = !_active
		if _active: enabled.emit()
		else: 		disabled.emit()
func set_button_toggle_mode(_mode: bool) -> void:
	if button: button.toggle_mode = _mode

func toggle(_is_toggled: bool) -> void:
	match _is_toggled:
		true:
			button.button_pressed = true
			hover_entered.emit()
			toggled.emit(true)
		false:
			button.button_pressed = false
			hover_exited.emit()
			toggled.emit(false)
