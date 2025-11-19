extends SBComponent

const DEFAULT_DYNAMIC_ROT_MULTI = 1

var sprite_renderer: SpriteSheetFormatter
@export var sprite_container: Node2D

var dynamic_rot_intensity: float = 3.85
var dynamic_rot_multi: float = DEFAULT_DYNAMIC_ROT_MULTI
@export var dynamic_rot: bool = true

func _setup(_sentient: SentientBase = null) -> void:
	super(_sentient)
	sprite_renderer = sentient.sprite_renderer
	if sprite_container == null: sprite_container = sprite_renderer
	
	(sentient.sprite_renderer as SpriteSheetFormatter).row = sentient.heading
func _update(_delta: float) -> void:
	handle_sprite_flip(sentient)
	handle_sprite_subtle_rotation(sentient)		
	handle_sprite_direction(sentient)

func handle_sprite_subtle_rotation(_sentient: SentientBase) -> void:
	if _sentient != null and dynamic_rot:
		_sentient.sprite_renderer.rotation_degrees = lerp(
			_sentient.sprite_renderer.rotation_degrees, 
			abs((_sentient.velocity.x / _sentient.BASE_SPEED) * dynamic_rot_intensity * dynamic_rot_multi),
			(get_process_delta_time()) / _sentient.TRANS_WEIGHT)
func handle_sprite_flip(_sentient: SentientBase) -> void:
	if _sentient != null:
		if _sentient.direction.x < 0: 	sprite_container.scale.x = -1
		elif _sentient.direction.x > 0: sprite_container.scale.x = 1
func handle_sprite_direction(_sentient: SentientBase) -> void:
	if sentient.is_moving: 	lerp_spr_dir(_sentient, _sentient.heading)
	else: 					set_spr_dir(_sentient, _sentient.heading)

func lerp_spr_dir(_sentient: SentientBase, _heading: SentientBase.compass_headings) -> void:
	_sentient.sprite_renderer.row = (lerpf(_sentient.sprite_renderer.row, _heading, _sentient.TRANS_WEIGHT))
func set_spr_dir(_sentient: SentientBase, _heading: SentientBase.compass_headings) -> void: 
	_sentient.sprite_renderer.row = _heading
func set_dynamic_rot_multi(_multi: float) -> void:
	dynamic_rot_multi = _multi
