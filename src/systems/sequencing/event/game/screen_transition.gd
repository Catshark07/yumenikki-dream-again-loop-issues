@tool

class_name EVN_ScreenTransition
extends Event

@export_category("Screen Fade Properties.")
@export var fade_type: ScreenTransition.fade_type
@export var fade_shader: ShaderMaterial

@export_group("Fade speed and colour")
@export var duration: float = 1
@export var a: float = 0
@export var b: float = 1
@export var hide_if_alpha_zero: bool = true
@export var gradient: Gradient = preload("res://src/main/default_transition_gradient.tres").duplicate()

@export_group("Tween properties")
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease: Tween.EaseType = Tween.EASE_OUT

func _execute() -> void:
	GameManager.secondary_transition.set_transition(
		duration,
		fade_shader,
		transition,
		ease)

	match fade_type:
		ScreenTransition.fade_type.FADE_IN	: await GameManager.secondary_transition.fade(gradient, a, b, hide_if_alpha_zero)
		ScreenTransition.fade_type.FADE_OUT	: await GameManager.secondary_transition.fade(gradient, b, a, hide_if_alpha_zero)
