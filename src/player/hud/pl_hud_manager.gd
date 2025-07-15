class_name PLHUD
extends Control

static var instance

@export var hide_on_inv: Control
var ui_tween: Tween

@export var save_icon: TextureRect
@export var save_icon_timer: Timer

# ---- listeners ----
var hud_fade: EventListener
var on_invert: EventListener
var game_save: EventListener

@export var inv: FSM

func _ready() -> void:
	instance = self
	events_setup()
	inv._setup(self)
	
func show_ui(_ui: Node, _show: bool) -> void:	
	if ui_tween != null: ui_tween.kill()
	ui_tween = _ui.create_tween()
	ui_tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO)
	
	match _show:
		true: 	ui_tween.tween_property(_ui, "modulate:a", 1, .5)
		false: 	ui_tween.tween_property(_ui, "modulate:a", 0, .5)
		
func events_setup() -> void:
	hud_fade = EventListener.new(["SCENE_CHANGE_REQUEST", "SCENE_CHANGE_SUCCESS"], false, self)
	hud_fade.do_on_notify(["SCENE_CHANGE_REQUEST",], func(): show_ui(self, false))
	hud_fade.do_on_notify(["SCENE_CHANGE_SUCCESS"], func(): show_ui(self, true))

	on_invert = EventListener.new(["SPECIAL_INVERT_CUTSCENE_BEGIN", "SPECIAL_INVERT_CUTSCENE_END"], false, self)
	on_invert.do_on_notify(["SPECIAL_INVERT_CUTSCENE_BEGIN"], func(): if hide_on_inv: show_ui(hide_on_inv, false))
	on_invert.do_on_notify(["SPECIAL_INVERT_CUTSCENE_END"], func(): if hide_on_inv: show_ui(hide_on_inv, true))
	
	game_save = EventListener.new(["GAME_FILE_SAVE", "GAME_CONFIG_SAVE"], false, self)
	game_save.do_on_notify(
		["GAME_CONFIG_SAVE"],
		func(): 
			save_icon.texture = preload("res://src/images/config_save.png")
			show_ui(save_icon, true)
			save_icon_timer.wait_time = 1
			save_icon_timer.start()
			await save_icon_timer.timeout
			show_ui(save_icon, false)
			)	
	game_save.do_on_notify(
		['GAME_FILE_SAVE'],
		func(): 
			save_icon.texture = preload("res://src/images/save.png")
			show_ui(save_icon, true)
			save_icon_timer.wait_time = 1
			save_icon_timer.start()
			await save_icon_timer.timeout
			show_ui(save_icon, false)
			)
	
