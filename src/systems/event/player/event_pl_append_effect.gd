extends Event

@export var effect: PLEffect

func _execute() -> void:
	EventManager.invoke_event("PLAYER_EFFECT_FOUND", [effect])
	super()
