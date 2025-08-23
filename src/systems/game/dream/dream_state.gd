extends State

@export var hud: PLHUD

func _enter_state() -> void: hud.show_ui(hud.indicators, true)
func _exit_state() -> void: hud.show_ui(hud.indicators, false)
	
func input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_hud_toggle"): hud.show_ui(hud.indicators, !hud.indicators.visible)
	if Input.is_action_just_pressed("pl_inventory"):  EventManager.invoke_event("SPECIAL_INVERT_START_REQUEST")
