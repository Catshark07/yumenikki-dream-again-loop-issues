extends State

@export var path_follow_cam: PathFollow2D
@export var path_follow_ui: PathFollow2D
@export var to_load_button: AbstractButton
@export var load_buttons: Array[GUIPanelButton]

@export var prompt_yes: GUIPanelButton
@export var prompt_no: GUIPanelButton
@export var prompt: Control

var tween: Tween
var pending_load_id: int = 0

func _enter_state() -> void:
	prompt.get_node("prompt").text_display.text = "Are you sure you want to load data from this slot?"
	
	for load in load_buttons: 
		GlobalUtils.connect_to_signal(_load_data.bind(int(load.name)), load.pressed)
		
	GlobalUtils.connect_to_signal(Save.load_data.bind(pending_load_id), prompt_yes.pressed)
	
	to_load_button.set_active(false)
	
	if tween != null: tween.kill()
	tween = self.create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_EXPO).set_parallel()
	tween.tween_property(path_follow_cam, "progress_ratio", 1, 2)
	tween.tween_property(path_follow_ui, "progress_ratio", 1, 2)

func _exit_state() -> void:
	for load in load_buttons:
		GlobalUtils.disconnect_from_signal(open_prompt, load.pressed)
	GlobalUtils.disconnect_from_signal(Save.load_data.bind(pending_load_id), prompt_yes.pressed)
	to_load_button.set_active(true)

func _load_data(_slot: int = 0) -> void: 
	Save.load_data(_slot)
	
func open_prompt() -> void: prompt.visible = true
