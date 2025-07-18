# ---- 	!!IMPORTANT !! 	----
# - ensure that any object that uses this class is a... -
# - ... derivative of CharacterBody2D ... 				-
# ----					----

class_name SentientBase
extends Entity.SentientEntity

var world_warp: Area2D
var components: SBComponentReceiver
const TRANS_WEIGHT := 0.225

const BASE_SPEED: float = 27.5
const SPRINT_MULT: float = 2.3
const MAX_SPEED: float = 35

@export_category("Base Entity Behaviour")

var sprite_renderer: Sprite2D
var shadow_renderer: Sprite2D # -- optional
var desired_vel: Vector2

@export_subgroup("Direction Vectors")
var lerped_direction: Vector2 = Vector2.DOWN

#region ---- mobility and velocity properties ----
@export_group("Mobility Values")

var speed: float = 0
var speed_multiplier: float = 1
@export var initial_speed: float = BASE_SPEED

var abs_velocity: Vector2:
	get: return abs(self.velocity)
var normalized_vel: Vector2:
	get: return self.velocity.normalized()

@export_group("Auditorial")
var noise_multi: float = 1
#endregion

func _ready() -> void:
	add_to_group("sentients")
	
	sprite_renderer = get_node_or_null("sprite_renderer")
	shadow_renderer = get_node_or_null("shadow_renderer")
	
	world_warp = get_node_or_null("world_warp")
	components = $sb_components
	components._setup(self)
		
	await self.ready
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	dependency_components()
	dependency_setup()
	
func _exit() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(true)
func _enter() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(false)
	
func dependency_components() -> void: pass 	
func dependency_setup() -> void: pass 

# ---- base processes ----
func _physics_update(_delta: float) -> void:
	(self as SentientBase).move_and_slide()
	
	components._physics_update(_delta)
	abs_velocity = abs(self.velocity)
	speed = abs_velocity.length()
	
func _update(_delta: float) -> void:
	is_moving = (self as SentientBase).abs_velocity != Vector2.ZERO	
	
	_handle_heading(direction)
	components._update(_delta)

#region ---- velocity and acceleration handling ----
func handle_velocity(_dir: Vector2, _mult: float = 1) -> void:
	if _dir.length() > 0: 
		desired_vel = ((_dir.normalized() * initial_speed) * _mult)
		self.velocity = desired_vel
	else: self.velocity = Vector2.ZERO
	
#endregion
#region ---- direction ----

func get_dir() -> Vector2: 
	return self.direction
func get_lerped_dir() -> Vector2: 
	return self.lerped_direction

func lerp_dir(_dir: Vector2, interpolation_multi: float = 1) -> void:
	if _dir != Vector2.ZERO: 
		lerped_direction = lerped_direction.lerp(_dir, interpolation_multi)
func look_at_dir(_dir: Vector2) -> void: 
	if _dir != Vector2.ZERO: 
		direction = _dir
		lerp_dir(_dir, TRANS_WEIGHT)
#endregion

func handle_noise() -> void:
	noise = (self.speed / self.MAX_SPEED) * noise_multi
