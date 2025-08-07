class_name ScreenTransition
extends ColorRect

var DEFAULT_SHADER: Shader = preload("res://src/shaders/transition/tr_fade.gdshader")

var fade_in_shader: ShaderMaterial
var fade_out_shader: ShaderMaterial
var default_shader: ShaderMaterial

var fade_tween: Tween
var fade_progress: float = 0:
	set = set_fade_progress

enum fade_type {FADE_IN, FADE_OUT}

func _ready() -> void:
	self.z_index = 99
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	
	fade_in_shader = ShaderMaterial.new()
	fade_out_shader = ShaderMaterial.new()
	default_shader = ShaderMaterial.new()
	
	default_shader.shader = DEFAULT_SHADER
	fade_in_shader = default_shader
	fade_out_shader = default_shader
	# im so confused
	
	self.size = Vector2(Application.get_viewport_dimens())
	
	request_transition(fade_type.FADE_OUT)

func fade_in(
	_speed: float = 1,
	_shader: ShaderMaterial = fade_in_shader,
	_start_progress: float = 0,
	_end_progress: float = 1,
	_transition: Tween.TransitionType = Tween.TRANS_LINEAR,
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void:
		 
		if fade_tween != null: fade_tween.kill()
		fade_tween = self.create_tween()
		
		if _shader == null: self.material = default_shader
		else: self.material = _shader
		
		self.material.set_shader_parameter("progress", 0)
		
		fade_tween.tween_method(
			set_fade_progress,
			_start_progress, 
			_end_progress, 
			(1 / _speed) if _speed > 0 else 1).set_trans(_transition).set_ease(_ease)
			
		await fade_tween.finished
		reset_fade_shaders()
func fade_out(
	_speed: float = 1, 
	_shader: ShaderMaterial = fade_out_shader,
	_start_progress: float = 1,
	_end_progress: float = 0,
	_transition: Tween.TransitionType = Tween.TRANS_LINEAR,
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void:
		
		if fade_tween != null: fade_tween.kill()
		fade_tween = self.create_tween()
		
		if _shader == null: self.material = default_shader
		else: self.material = _shader
		self.material.set_shader_parameter("progress", 1)
		
		fade_tween.tween_method(
			set_fade_progress,
			_start_progress, 
			_end_progress, 
			(1 / _speed) if _speed > 0 else 1).set_trans(_transition).set_ease(_ease)
			
		await fade_tween.finished
func set_fade_progress(_progress):
	fade_progress = _progress
	self.material.set_shader_parameter("progress", fade_progress)
	
func request_transition(
	_fade_type: fade_type, 
	_colour: Color = Color.BLACK,
	_speed: float = 1,
	_custom_shader: ShaderMaterial = null,
	_a_progress: float = 0,
	_b_progress: float = 1,
	_transition: Tween.TransitionType = Tween.TRANS_LINEAR,
	_ease: Tween.EaseType = Tween.EASE_OUT) -> void:
		
	self.color = _colour
	match _fade_type:
		fade_type.FADE_IN: await fade_in(_speed, _custom_shader, _a_progress, _b_progress, _transition, _ease)
		fade_type.FADE_OUT: await fade_out(_speed, _custom_shader, _b_progress, _a_progress, _transition, _ease)

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
	fade_in_shader.shader = DEFAULT_SHADER
	fade_out_shader.shader = DEFAULT_SHADER
