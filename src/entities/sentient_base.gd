class_name SentientBase
extends Entity

var vel_input: Vector2i:
	set(input): 
		vel_input.x = clamp(input.x, -1, 1)
		vel_input.y = clamp(input.y, -1, 1)
var dir_input: Vector2i:
	set(input): 
		dir_input.x = clamp(input.x, -1, 1)
		dir_input.y = clamp(input.y, -1, 1)

var is_moving: bool = false

var components: SBComponentReceiver

var noise: 			float = 0

# - consts
const TRANS_WEIGHT:	float = 0.225
const BASE_SPEED: 	float = 27.5
const MAX_SPEED: 	float = 95

# - sprites
var sprite_renderer: Sprite2D
var shadow_renderer: Sprite2D 

# - vel and speed.
var desired_vel: Vector2
var desired_speed: float

# - direction
enum compass_headings {
	NORTH = 0,
	NORTH_HORIZ = 1,
	HORIZ = 2,
	SOUTH_HORIZ = 3,
	SOUTH = 4}
var heading: compass_headings

var direction: Vector2 = Vector2(0, 1):
	set(dir): 
		direction.x = clamp(dir.x, -1, 1)
		direction.y = clamp(dir.y, -1, 1)
var lerped_direction: Vector2 = Vector2.DOWN

@export_category("Base Entity Behaviour")
@export_group("Mobility Values")

var speed_multiplier: float = 1
var speed: float = 0

@export_group("Auditorial")
var noise_multi: float = 1

func _ready() -> void:
	sprite_renderer = get_node_or_null("sprite_renderer")
	shadow_renderer = get_node_or_null("shadow_renderer")
	
	components = $sb_components
	components._setup(self)
		
	self.motion_mode = CharacterBody2D.MOTION_MODE_FLOATING
	
	dependency_components()
	dependency_setup()
	
func _enter_tree() -> void: add_to_group("actors")
func _exit_tree() -> void:  remove_from_group("actors")
	
func _freeze() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(true)
func _unfreeze() -> void: 
	self.velocity = Vector2.ZERO
	components.set_bypass(false)
	
func _exit() -> void: _freeze()
func _enter() -> void: _unfreeze()
	
func dependency_components() -> void: pass 	
func dependency_setup() -> void: pass 

# ---- base processes ----
func _physics_update(_delta: float) -> void:
	(self as SentientBase).move_and_slide()
	
	components._physics_update(_delta)
	speed 			= abs(self.velocity).length()
	
	handle_desired_velocity(vel_input)
func _update(_delta: float) -> void:
	is_moving = speed > 0	
	components._update(_delta)
func _sb_input(_event: InputEvent) -> void: 
	pass

func handle_noise() -> void:
	noise = (self.speed / self.MAX_SPEED) * noise_multi
func handle_velocity(_multi: float = 1) -> void:
	speed_multiplier = _multi
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

func handle_desired_velocity(_dir: Vector2) -> void:
	desired_vel = ((_dir.normalized() * BASE_SPEED))
	desired_speed 	= desired_vel.length()
	
