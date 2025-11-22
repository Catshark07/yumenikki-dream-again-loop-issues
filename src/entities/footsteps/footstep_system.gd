class_name Footstep
extends SBComponent

# update the sounds later.
# one more thing: make a ground_material resource that holds a list
# of all random sound effects for the ground.

const DEFAULT_FOOTSTEP: AudioStream 	= preload("res://src/audio/se/footstep_null-1.wav")
const DEFAULT_FOOTSTEP_MAT: FootstepSet = preload("res://src/audio/footsteps/null.tres")
static var default_footstep_mat: FootstepSet = DEFAULT_FOOTSTEP_MAT

var curr_set: FootstepSet:
	get: 
		if curr_set == DEFAULT_FOOTSTEP_MAT: return default_footstep_mat
		return curr_set

var curr_anim: CompressedTexture2D = preload("res://src/entities/footsteps/default.png")

var footstep_se_player: SoundPlayer2D
var area: Area2D

var floor_priority: TileMapLayer
var greatest_index: int = -50
var material_id: int = 0

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
	
	curr_set = default_footstep_mat
	print(default_footstep_mat)
	sentient.shadow_renderer.visible = !curr_set.transparent_tile
	footstep_se_player.max_distance = 250

func initate_footstep() -> void:  
	curr_anim = curr_set.footstep_anim
	spawn_footstep_fx()
	play_footstep_sound(curr_set.pick_random() if curr_set.size() > 0 else DEFAULT_FOOTSTEP)
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
		sentient.shadow_renderer.visible = !curr_set.transparent_tile
				
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
					curr_set = default_footstep_mat
					floor_priority = null
					sentient.shadow_renderer.visible = false
					
func scan_ground_material() -> void:
	for floors: FootstepTileMap in multiple_floors.arr:
		if floors.z_index > greatest_index: 
			greatest_index = floors.z_index
			floor_priority = floors
			curr_set = floor_priority.get_footstep_material()
			break
		
class FootstepDust:
	extends SpriteSheetFormatterAnimated

	func _init(_anim: CompressedTexture2D, ) -> void:
		Optimization.footstep_instances += 1
		
		self.frame_dimensions = Vector2i(48, 48)
		self.fps = 22
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
