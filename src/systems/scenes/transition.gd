class_name ScreenTransition
extends TextureRect

const DEFAULT_SHADER: Shader = preload("res://src/shaders/transition/tr_fade.gdshader")
var default_texture: GradientTexture1D

var fade_in_shader: 	ShaderMaterial
var fade_out_shader: 	ShaderMaterial
var default_shader: 	ShaderMaterial

var fade_tween: Tween
var fade_progress: float = 0:
	set = set_fade_progress

enum fade_type {FADE_IN, FADE_OUT}

# - transition animation properties.
var transition_type: 	Tween.TransitionType = Tween.TRANS_LINEAR
var ease_type: 			Tween.EaseType = Tween.EASE_OUT
var speed: float = 1

func _ready() -> void:
	default_texture = GradientTexture1D.new()
	default_texture.gradient = Gradient.new()
	default_texture.gradient.colors = PackedColorArray([Color.BLACK])
	
	texture = default_texture
	
	self.z_index = 99
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	fade_in_shader = ShaderMaterial.new()
	fade_out_shader = ShaderMaterial.new()
	default_shader = ShaderMaterial.new()
	
	default_shader.shader = DEFAULT_SHADER
	fade_in_shader = default_shader
	fade_out_shader = default_shader
	
	self.size = Vector2(Application.get_viewport_dimens())
	self.material = default_shader
	self.visible = false

func fade_in(
	_start_progress: float = 0,
	_end_progress: float = 1) -> void:
		
		if fade_tween != null: fade_tween.kill()
		fade_tween = self.create_tween()
		
		self.visible = true 
		self.material.set_shader_parameter("progress", 0)
		
		fade_tween.tween_method(
			set_fade_progress,
			_start_progress, 
			_end_progress, 
			(1.0 / speed) if speed > 0.0 else 1.0).set_trans(transition_type).set_ease(ease_type)
			
		await fade_tween.finished
func fade_out(
	_start_progress: float = 1,
	_end_progress: float = 0) -> void:
		self.visible = true 
		
		if fade_tween != null: fade_tween.kill()
		fade_tween = self.create_tween()
		
		self.material.set_shader_parameter("progress", 1)
		
		fade_tween.tween_method(
			set_fade_progress,
			_start_progress, 
			_end_progress, 
			(1.0 / speed) if speed > 0.0 else 1.0).set_trans(transition_type).set_ease(ease_type)
			
		await fade_tween.finished
		
		if _end_progress <= 0:
			self.visible = false 
		
func set_fade_progress(_progress):
	fade_progress = _progress
	self.material.set_shader_parameter("progress", fade_progress)

func set_transition(
	_colour: Color = Color.BLACK,
	_speed: float = 1,
	_custom_shader: ShaderMaterial = null,
	_transition: Tween.TransitionType = Tween.TRANS_LINEAR,
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void: 
		self.modulate 			= _colour
		self.transition_type 	= _transition
		self.ease_type 			= _ease
		self.speed				= _speed
		
		if _custom_shader == null: self.material = default_shader
		else: self.material = _custom_shader
func set_fade_out_shader(_shader: ShaderMaterial) -> void: 
	if _shader.shader == null: 
		fade_out_shader.shader = DEFAULT_SHADER
		self.material = fade_out_shader
		return
		
	fade_out_shader = _shader
	self.material = _shader
func set_fade_in_shader(_shader: ShaderMaterial) -> void:
	if _shader.shader == null: 
		fade_in_shader.shader = DEFAULT_SHADER
		self.material = fade_in_shader
		return
		
	fade_in_shader = _shader
	self.material = _shader

func reset_fade_shaders() -> void:
	self.material = default_shader
