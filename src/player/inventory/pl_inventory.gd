class_name PLInventory
extends FSM

var player_equip_listener: EventListener
var special_invert_sequence_end: EventListener

@export var display: Control

@export var white_petal: Control
@export var pink_petal: Control

@export var white_petal_button: AbstractButton
@export var pink_petal_button: AbstractButton

@export var item_container: GridContainer

@export var deequip_prompt: AbstractButton
@export var effect_indicator: SpriteSheetFormatter

var petal_tween: Tween

var hovered_button: GUIPanelButton
static var favourite_effect: PLSystemData
@export var favourite_icon: Sprite2D

signal inventory_data_changed(_new_data: PLInventoryData)
signal inventory_data_updated(_appended_effect: PLSystemData)

var data: PLInventoryData = DEFAULT_DATA
const DEFAULT_DATA: PLInventoryData = preload("res://src/player/inventory/data/empty.tres")
const DEBUG_DATA: PLInventoryData = preload("res://src/player/inventory/data/all_effects.tres")

func _enter() -> void: 
	(self.visible) = true
	curr_state._enter_state()
func _exit() -> void: 
	(self.visible) = false
	curr_state._exit_state()

func _setup(_owner: Node, _skip_initial_state_setup: bool = false) -> void:
	white_petal.visible = false
	pink_petal.visible = false
	
	super(_owner, _skip_initial_state_setup)
	
	special_invert_sequence_end = EventListener.new(
		["SCENE_CHANGE_REQUEST", "PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	special_invert_sequence_end.do_on_notify(
		["SCENE_CHANGE_REQUEST", "PLAYER_EQUIP", "PLAYER_DEEQUIP"], 
		EventManager.invoke_event.bind("SPECIAL_INVERT_END_REQUEST"))
	
	player_equip_listener = EventListener.new(["PLAYER_EQUIP", "PLAYER_DEEQUIP"], false, self)
	player_equip_listener.do_on_notify(["PLAYER_DEEQUIP"], func(): 
		deequip_prompt.set_active(false)
		effect_indicator.progress = 1
		)
	player_equip_listener.do_on_notify(["PLAYER_EQUIP"], func(): 
		if EventManager.get_event_param("PLAYER_EQUIP")[0] == Player.Instance.DEFAULT_EQUIPMENT: 
			return
		deequip_prompt.set_active(true)
		effect_indicator.progress = 0
		)
	
	GlobalUtils.connect_to_signal( # - dequip effect if dequip sigil is pressed.
		func():(Player.Instance.get_pl() as Player_YN).deequip_effect(), deequip_prompt.pressed)

	GlobalUtils.connect_to_signal( # - change to white petal menu on white petal button.
		func(): change_to_state("white_petal"), white_petal_button.pressed)
	GlobalUtils.connect_to_signal( # - change to pink petal menu on pink petal button.
		func(): change_to_state("pink_petal"), pink_petal_button.pressed)
	
	if OS.is_debug_build(): update_inventory(DEBUG_DATA)
	else: 					update_inventory(data)

func instantiate_buttons(_inv_data: PLInventoryData) -> void:
	if _inv_data == null: return
	for effect in _inv_data.effects:
		append_item(effect)
func delete_buttons() -> void: 
	for i in item_container.get_children():
		i.queue_free()

func append_item(_item: PLSystemData) -> void: 
	if _item == null or _item in data.effects: return
	data.effects.append(_item)
	
	var button = GUIPanelButton.new()
	button.custom_minimum_size = Vector2(80, 20)
	item_container.add_child(button)
	
	button.abstract_button.unique_data = _item
	button.text_display.text = (_item.name)
	button.icon_display.texture = (_item.icon)
	
	button.name = (_item.name)
	button.hover_exited.connect(func(): hovered_button = null)
	button.hover_entered.connect(func(): hovered_button = button)	
	button.pressed.connect(func():
		if button.abstract_button.unique_data:
			EventManager.invoke_event("SPECIAL_INVERT_END_REQUEST")
			(Player.Instance.get_pl() as Player_YN).equip(button.abstract_button.unique_data))
	
	inventory_data_updated.emit(_item)
	
	Player.Data.update_effects_data(data.effects)

func update_inventory(_data: PLInventoryData) -> void:
	delete_buttons()
	instantiate_buttons(_data)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_favourite_effect"):
		if hovered_button != null: 
			favourite_effect = hovered_button.abstract_button.unique_data
			favourite_icon.global_position = hovered_button.global_position
