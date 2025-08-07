# ---- 	!!IMPORTANT !! 	----
# - ensure that any object that uses this class is a... -
# - ... derivative of CharacterBody2D ... 				-
# ----					----

class_name SentientBase
extends Entity

var vel_input: Vector2i
var dir_input: Vector2i

var noise: 			float = 0
var is_moving: bool = false

var world_warp: Area2D
var components: SBComponentReceiver

const TRANS_WEIGHT:	float = 0.225
const BASE_SPEED: 	float = 27.5
const SPRINT_MULT: 	float = 2.3
const MAX_SPEED: 	float = 95

var sprite_renderer: Sprite2D
var shadow_renderer: Sprite2D 

var desired_vel: Vector2
var desired_speed: float
var lerped_direction: Vector2 = Vector2.DOWN

@export_category("Base Entity Behaviour")

#region ---- mobility and velocity properties ----
@export_group("Mobility Values")

var speed: float = 0
var speed_multiplier: float = 1
var abs_velocity: Vector2:
	get: return abs(self.velocity)

@export_group("Auditorial")
var noise_multi: float = 1
#endregion

func _ready() -> void:
	sprite_renderer = get_node_or_null("sprite_renderer")
	shadow_renderer = get_node_or_null("shadow_renderer")
	
	world_warp = get_node_or_null("world_warp")
	components = $sb_components
	components._setup(self)
		
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	dependency_components()
	dependency_setup()
	
func _enter_tree() -> void: add_to_group("sentients")
func _exit_tree() -> void:  remove_from_group("sentients")
	
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
	abs_velocity 	= abs(self.velocity)
	speed 			= abs_velocity.length()
	desired_speed 	= desired_vel.length()
	
	handle_velocity(vel_input)
	handle_heading()
func _update(_delta: float) -> void:
	is_moving = (self as SentientBase).abs_velocity != Vector2.ZERO	
	components._update(_delta)

func handle_noise() -> void:
	noise = (self.speed / self.MAX_SPEED) * noise_multi

func handle_velocity(_dir: Vector2) -> void:
	desired_vel = ((_dir.normalized() * BASE_SPEED))
	self.velocity = Vector2(desired_vel * speed_multiplier).limit_length(MAX_SPEED) 
	if (self.velocity.is_equal_approx(Vector2.ZERO)): self.position = self.position.round()
		
func handle_direction(_dir: Vector2) -> void: 
	if _dir != Vector2.ZERO:
		direction = _dir
		lerped_direction = lerped_direction.lerp(_dir, 1)
func handle_heading() -> void:
		if abs(direction.x) > .5: 
			if direction.y > .5: heading = compass_headings.SOUTH_HORIZ
			elif direction.y < -.5: heading = compass_headings.NORTH_HORIZ
			else: heading = compass_headings.HORIZ
		else:
			if direction.y > .5: heading = compass_headings.SOUTH
			elif direction.y < -.5: heading = compass_headings.NORTH
