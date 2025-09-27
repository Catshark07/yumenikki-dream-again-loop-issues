class_name PLInventory
extends Control

@export var fsm: FSM
@export var display: Control
@export var item_container: GridContainer

var hovered_button: GUIPanelButton
@export var favourite_icon: Sprite2D

var effects: Array[PLEffect]
var effect_buttons: Array[GUIPanelButton]

# - initializaiton (called from special invert state).
func _setup() -> void:
	fsm._setup(self)
		
func _enter() -> void: 
	(self.visible) = true
	fsm.curr_state._state_enter()
func _exit() -> void: 
	(self.visible) = false
	fsm.curr_state._state_exit()

# - adding items.
func delete_buttons() -> void: 
	effects.clear()
	for i in item_container.get_children():
		i.queue_free()
func add_item(_item: PLEffect) -> void: 
	if _item == null or _item in effects: return
	effects.append(_item)
	var button = GUIPanelButton.new()
	effect_buttons.append(button)
	
	item_container.add_child(button)
	button.custom_minimum_size = Vector2(75, 20)
	
	button.abstract_button.unique_data = _item
	button.text_display.text = (_item.name)
	button.icon_display.texture = (_item.icon)
	
	button.name = (_item.name)
	button.on_hover.	connect(func(): hovered_button = button)	
	button.on_unhover.	connect(func(): hovered_button = null)
	button.pressed.		connect(func():
		if button.abstract_button.unique_data:
			EventManager.invoke_event("SPECIAL_INVERT_END_REQUEST")
			(Player.Instance.get_pl() as Player_YN).equip(button.abstract_button.unique_data))

# - removing items.
func remove_item(_item: PLEffect) -> void:
	var item_idx := effects.find(_item)
	if item_idx > 0: effects.remove_at(0)
	
	for i in effect_buttons:
		if i.abstract_button.unique_data == _item: i.queue_free()
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_favourite_effect"):
		if hovered_button != null: 
			Player.Instance.equipment_favourite = hovered_button.abstract_button.unique_data
			favourite_icon.global_position = hovered_button.global_position
