extends Event

@export_category("Screen Fade Properties.")
@export var fade_type: ScreenTransition.fade_type
@export var fade_shader: ShaderMaterial

@export_group("Fade speed and colour")
@export var fade_speed: float = 1
@export var a: float = 0
@export var b: float = 1

@export_group("Tween properties")
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease: Tween.EaseType = Tween.EASE_OUT

func _execute() -> void:
	GameManager.secondary_transition.set_transition(
		fade_speed,
		fade_shader,
		transition,
		ease)

	match fade_type:
		ScreenTransition.fade_type.FADE_IN	: await GameManager.secondary_transition.fade(a, b)
		ScreenTransition.fade_type.FADE_OUT	: await GameManager.secondary_transition.fade(b, a)
