class_name Player
extends SentientBase

@export var fsm: SentientFSM

#region ---- data variables ----

var data: PLAttributeData

@export_group("Mobility Multiplier")
@export_storage var walk_multiplier: float = WALK_MULTI
@export_storage var sneak_multiplier: float = SNEAK_MULTI
@export_storage var sprint_multiplier: float = SPRINT_MULTI
@export_storage var exhaust_multiplier: float = EXHAUST_MULTI

@export_group("Stamina Modifier")
@export_storage var stamina_drain: float = STAMINA_DRAIN
@export_storage var stamina_regen: float = STAMINA_REGEN
@export_storage var stamina: float = MAX_STAMINA:
	set(_stam):
		stamina = _stam
		EventManager.invoke_event("PLAYER_STAMINA_CHANGE", [_stam])

var is_exhausted: bool = false
@export_storage var can_run: bool = CAN_RUN

# ---- data constants ----
const CAN_RUN: bool = true

const WALK_MULTI: float = 1.25
const SNEAK_MULTI: float = 0.735
const SPRINT_MULTI: float = 2.9
const EXHAUST_MULTI: float = 0.9

const MAX_STAMINA := 5
const STAMINA_DRAIN: float = .78
const STAMINA_REGEN: float = .8

const WALK_NOISE_MULTI: float = 1
const RUN_NOISE_MULTI: float = 2.2
const SNEAK_NOISE_MULTI: float = 0.5

var walk_noise_mult: float = WALK_NOISE_MULTI
var run_noise_mult: float = RUN_NOISE_MULTI
var sneak_noise_mult: float =SNEAK_NOISE_MULTI
#endregion ---- data variables ----

# ---- signals ----
signal quered_primary_action
signal quered_secondary_action
signal quered_teritiary_action

signal quered_interact

signal quered_sprint_start
signal quered_sprint_end

signal quered_sneak_start
signal quered_sneak_end

# ---- initial ----
func _enter_tree() -> void: 
	super()
	Instance._pl = self
	EventManager.invoke_event("PLAYER_UPDATED")

func force_change_state(_new: String) -> void: fsm.get_curr_state().request_transition_to(_new)
func get_state_name() -> String: return fsm.get_curr_state_name()

class Data:
	static var content: Dictionary = {		
		"data" : 
			{
			"innocent_killed" : 0,
			"hostile_killed" : 0,
			},
		"effects" : [],
		}
	
	static var effects: Array[PLEffect]
	
	static func get_effects_as_path() -> PackedStringArray:
		var arr = []
		for i in effects:
			arr.append(i.resource_path)
		
		return arr
			
class Instance:
	static var _pl: Player 
	
	static var is_setup: bool = false
	
	static var door_went_flag: bool = false
	static var door_listener: EventListener
	static var equipment_auto_apply: EventListener 

	const DEFAULT_EQUIPMENT = preload("res://src/player/2D/madotsuki/effects/_none/_default.tres")
	
	static var equipment_pending	: PLEffect = DEFAULT_EQUIPMENT
	static var equipment_favourite	: PLEffect = null
	static var effects_inventory: Array

	static func setup() -> void: 
		if is_setup: return
		is_setup = true
		
		door_listener = EventListener.new(["PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS"], true)
		door_listener.do_on_notify(["PLAYER_DOOR_USED"], func(): door_went_flag = true)
		door_listener.do_on_notify(["SCENE_CHANGE_SUCCESS"], func(): 
			
			for points: SpawnPoint in GlobalUtils.get_group_arr("spawn_points"):
				if (
					load(points.scene_path) == SceneManager.prev_scene_resource and 
					door_went_flag and
					EventManager.get_event_param("PLAYER_DOOR_USED")[0] == points.connection_id):
						
						teleport_player(points.global_position, points.spawn_dir, true)
						if points.parent_instead_of_self != null:
							if points.as_sibling: _pl.reparent(points.parent_instead_of_self.get_parent())
							else: _pl.reparent(points.parent_instead_of_self)

						else:
							if points.as_sibling: _pl.reparent(points.get_parent())
							else: _pl.reparent(points)
						
						door_went_flag = false
						break)

		equipment_auto_apply = EventListener.new(["SCENE_CHANGE_SUCCESS"], true)
		
		equipment_auto_apply.do_on_notify(
			["SCENE_CHANGE_SUCCESS"],
			func(): 
				if get_pl(): (get_pl() as Player_YN).equip(equipment_pending)
		)

	static func teleport_player(_pos: Vector2, _dir: Vector2, w_camera: bool = false) -> void:
		if get_pl():
			get_pl().global_position = _pos
			get_pl().direction = (_dir)
			if w_camera and CameraHolder.instance.initial_target == get_pl(): 
				CameraHolder.instance.global_position = get_pl().global_position

	
	static func pl_exists() -> bool: return (get_pl() != null)
	static func get_pl() -> Player: return _pl
	
	static func get_pos() -> Vector2:
		if pl_exists(): return _pl.global_position
		return Vector2.ZERO
	static func is_moving() -> bool:
		if pl_exists(): return _pl.is_moving
		return pl_exists()
