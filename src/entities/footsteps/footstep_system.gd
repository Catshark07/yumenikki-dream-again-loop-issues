class_name Footstep
extends SBComponent

# update the sounds later.
# one more thing: make a ground_material resource that holds a list
# of all random sound effects for the ground.

static var default_footstep: mat = mat.NULL
@export var transparent_surfaces := {
	mat.NULL 		: true,
	mat.CONCRETE 	: false,
	mat.WOOD		: false,
	mat.SNOW 		: false,
	mat.GRASS 		: false,
	mat.MUD 		: false,
	mat.BLOOD 		: false,
	mat.WATER 		: true,
	mat.CLOTH 		: false,
	mat.GLASS 		: true,
	mat.DIRT_FLESH 	: false,
}

enum mat {
	NULL 		= 0,
	CONCRETE 	= 1,
	WOOD 		= 2,
	SNOW 		= 3,
	GRASS 		= 4,
	MUD 		= 5,
	BLOOD 		= 6,
	WATER 		= 7,
	CLOTH		= 8,
	GLASS		= 9,
	DIRT_FLESH 	= 10,
	GRAVEL 		= 11
	}
var curr_material: mat
var GROUND_MAT_DICT := {
	mat.NULL 		: preload("res://src/audio/footsteps/null.tres"), 		# --- 0
	mat.CONCRETE 	: preload("res://src/audio/footsteps/concrete.tres"),	# --- 1
	mat.WOOD		: preload("res://src/audio/footsteps/wood.tres"),		# --- 2
	mat.SNOW 		: preload("res://src/audio/footsteps/snow.tres"),		# --- 3
	mat.GRASS 		: preload("res://src/audio/footsteps/grass.tres"),		# --- 4
	mat.MUD 		: preload("res://src/audio/footsteps/blood.tres"),		# --- 5
	mat.BLOOD 		: preload("res://src/audio/footsteps/blood.tres"),		# --- 6
	mat.WATER 		: preload("res://src/audio/footsteps/water.tres"),		# --- 7
	mat.CLOTH 		: preload("res://src/audio/footsteps/cloth.tres"),		# --- 8
	mat.GLASS 		: preload("res://src/audio/footsteps/glass.tres"),		# --- 9
	mat.DIRT_FLESH 	: preload("res://src/audio/footsteps/dirt_flesh.tres"),	# --- 10
	mat.GRAVEL 		: preload("res://src/audio/footsteps/gravel.tres"),	# --- 11
	}

var DEFAULT_FOOTSTEP: AudioStreamWAV = preload("res://src/audio/se/footstep_null-1.wav")
var curr_anim: CompressedTexture2D = preload("res://src/entities/footsteps/default.png")

var footstep_se_player: SoundPlayer2D
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50
var material_id: int = 0

var sound_to_be_played: AudioStream

@onready var multiple_floors := FootstepSet.new()

func _on_bypass_enabled() -> void:
	multiple_floors.arr.clear()
	floor_priority = null

func _setup(_sentient: SentientBase = null) -> void:
	super(_sentient)
	
	footstep_se_player 	= $sound_player
	area 				= $terrain_detector
	
	area.monitorable	= true
	area.monitoring 	= true
	area.input_pickable = false
	
	area.body_shape_exited.connect(_on_body_shape_exited)
	area.body_shape_entered.connect(_on_body_shape_entered)
	
	curr_material = default_footstep
	sentient.shadow_renderer.visible = transparent_surfaces[curr_material]
	footstep_se_player.max_distance = 250

func initate_footstep() -> void:  
	var sounds_set: FootstepSet = GROUND_MAT_DICT[curr_material]
	
	curr_anim = sounds_set.footstep_anim
	spawn_footstep_fx()
	
	if sound_to_be_played == null:
		play_footstep_sound(sounds_set.pick_random() if sounds_set.size() > 0 else DEFAULT_FOOTSTEP)
	else:
		play_footstep_sound(sound_to_be_played)
func spawn_footstep_fx() -> void: 
	if Optimization.footstep_instances < Optimization.FOOTSTEP_MAX_INSTANCES:
		var footstep_fx := FootstepDust.new(curr_anim)
		self.add_child(footstep_fx)
		footstep_fx.global_position = sentient.global_position

func play_footstep_sound(_footstep_se: AudioStream) -> void: 
	footstep_se_player.play_sound(
		_footstep_se, 
		clampf(2.1 *(log(sentient.noise + 1)), 0.5, 1.75), 
		clampf(randf_range(0.75, sentient.noise), 0.75, 1.2))	

func _on_body_shape_entered(
	_body_rid: RID, 
	_body: Node2D, 
	_body_shape_index: int, 
	_local_shape_index: int) -> void:
		
		if _body is FootstepTileMap:
			multiple_floors.append(_body)
								
		scan_ground_material()				
		sentient.shadow_renderer.visible = !transparent_surfaces[curr_material]
				
func _on_body_shape_exited(
	_body_rid: RID, 
	_body: Node2D, 
	_body_shape_index: int, 
	_local_shape_index: int) -> void:
		if _body is FootstepTileMap:
			
			if !area.overlaps_body(_body):
				multiple_floors.remove_at(multiple_floors.find(_body)) 
				greatest_index = -50
				scan_ground_material()
				
				if  multiple_floors.is_empty():
					curr_material = default_footstep
					floor_priority = null
					sentient.shadow_renderer.visible = false
					sound_to_be_played = null
					
func scan_ground_material() -> void:
	for floors: FootstepTileMap in multiple_floors.arr:
		if floors.z_index > greatest_index: 
			greatest_index = floors.z_index
			floor_priority = floors
			curr_material = floor_priority.ground_material
			break
		
class FootstepDust:
	extends SpriteSheetFormatterAnimated

	func _init(_anim: CompressedTexture2D, ) -> void:
		Optimization.footstep_instances += 1
		
		self.frame_dimensions = Vector2i(48, 48)
		self.fps = 18
		self.loop = false
		
		self.z_index = -1
		self.offset.y = -10
		self.top_level = true
		
		set_sprite(_anim)	
		
	func _exit_tree() -> void:
		Optimization.footstep_instances -= 1
		
	func _ready() -> void:
		self.play(texture)
		await self.animation_finished
		self.queue_free()
