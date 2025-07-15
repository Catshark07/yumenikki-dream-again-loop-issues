extends Event

@export var effect: PLEffect

func _execute() -> void:
	if effect == null: return
	EventManager.invoke_event("PLAYER_EFFECT_FOUND", [effect])
	super()
