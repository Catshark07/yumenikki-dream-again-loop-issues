class_name Player
extends SentientBase

@export var fsm: SentientFSM

#region ---- data variables ----

@export_storage var stamina: 		float = MAX_STAMINA:
	set(_stam):
		stamina = clampf(_stam, 0, MAX_STAMINA)
		EventManager.invoke_event("PLAYER_STAMINA_CHANGE", _stam)

var is_exhausted: bool = false

# ---- data constants ----
const CAN_SPRINT: bool = true
const EXHAUST_MULTI: 		float = 0.635

const MAX_STAMINA:	 		float =  5
const STAMINA_DRAIN: 		float = .78
const STAMINA_REGEN: 		float = .8

#endregion ---- data variables ----

# ---- signals ----
signal quered_primary_action
signal quered_secondary_action
signal quered_teritiary_action

signal quered_interact(_pl: Player, choice: int)

signal quered_sprint_start
signal quered_sprint_end

signal quered_sneak_start
signal quered_sneak_end

# ---- initial ----
func _enter_tree() -> void: 
	super()
	Instance._pl = self
	EventManager.invoke_event("PLAYER_UPDATED", self)

func force_change_state(_new: String) -> void: fsm.get_curr_state().request_transition_to(_new)
func get_state_name() -> String: return fsm.get_curr_state_name()

class Data:
	static var content: Dictionary = {		
		"innocent_killed" : 0,
		"hostile_killed" : 0,
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

	const DEFAULT_EQUIPMENT = preload("res://src/player/2D/madotsuki/effects/_none/_no_effect.tres")
	
	static var equipment_pending	: PLEffect = null
	static var equipment_favourite	: PLEffect = null
	static var effects_inventory: Array

	static func setup() -> void: 
		if is_setup: return
		is_setup = true
		
		door_listener = EventListener.new(null, "PLAYER_DOOR_USED", "SCENE_CHANGE_SUCCESS")
		door_listener.do_on_notify(func(): door_went_flag = true, "PLAYER_DOOR_USED")
		door_listener.do_on_notify(func(): 
			
			for points: SpawnPoint in Utils.get_group_arr("spawn_points"):
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
						break, 
					
			"SCENE_CHANGE_SUCCESS")

		equipment_auto_apply = EventListener.new(null, "SCENE_CHANGE_SUCCESS")
		
		equipment_auto_apply.do_on_notify(
			func(): 
				if get_pl(): (get_pl() as Player_YN).equip(equipment_pending), "SCENE_CHANGE_SUCCESS"
		)

	static func teleport_player(_pos: Vector2, _dir: Vector2, w_camera: bool = false) -> void:
		if get_pl():
			get_pl().global_position = _pos
			get_pl().direction = (_dir)
			if w_camera and CameraHolder.instance.initial_target == get_pl(): 
				CameraHolder.instance.global_position = get_pl().global_position

	
	static func pl_exists() -> bool: return (get_pl() != null)
	static func get_pl() -> Player: return _pl
	
	static func get_pos(_global: bool = true) -> Vector2:
		if pl_exists(): 
			if _global	: return _pl.global_position
			else		: return _pl.position
		return Vector2.ZERO
	static func is_moving() -> bool:
		if pl_exists(): return _pl.is_moving
		return pl_exists()
# --- 
func set_values(_val: SBVariables) -> void: 
	if _val == null: 
		values = PLVariables.new()
		values.resource_name = "pl_variables"
		values.resource_local_to_scene = true
		return
	
	values = _val.duplicate()
	values.resource_name = "pl_variables"
	values.resource_local_to_scene = true
