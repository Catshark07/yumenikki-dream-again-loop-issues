extends Event

@export_category("Screen Fade Properties.")
@export var fade_shader: ShaderMaterial = null

@export_group("Fade speed and colour")
@export var fade_colour: Color = Color.BLACK
@export var fade_speed: float = 1

@export_group("Tween properties")
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease: Tween.EaseType = Tween.EASE_OUT

func _execute() -> void:
	GameManager.secondary_transition.set_transition(
		fade_colour,
		fade_speed,
		fade_shader,
		transition,
		ease
	)
	super()
	
