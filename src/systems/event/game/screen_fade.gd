extends Event

@export_category("Screen Fade Properties.")
@export var fade_type: ScreenTransition.fade_type
@export var fade_shader: ShaderMaterial = null

@export_group("Fade speed and colour")
@export var fade_colour: Color = Color.BLACK
@export var fade_speed: float = 1
@export var start_progress: float = 0
@export var end_progress: float = 1

@export_group("Tween properties")
@export var transition: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease: Tween.EaseType = Tween.EASE_OUT

func _execute() -> void:
	if !wait_til_finished: super()
	await ScreenTransition.request_transition(
		fade_type, 
		fade_colour, 
		fade_speed, 
		fade_shader,
		start_progress,
		end_progress,
		transition,
		ease)
	
	if wait_til_finished: super()
