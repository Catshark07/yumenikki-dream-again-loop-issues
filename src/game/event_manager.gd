class_name EventManager

static func add_listener(_listener: EventListener, _id: String) -> void:
	create_event(_id)
	event_ids[_id]["subscribers"].append(_listener)
static func remove_listener(_listener: EventListener, _id: String) -> void:
	create_event(_id)
	if  event_ids[_id]["subscribers"].find(_listener) != -1:
		event_ids[_id]["subscribers"].remove_at(
			event_ids[_id]["subscribers"].find(_listener)
			)
static func create_event(_id: String) -> void:
	if !event_ids.has(_id):
		event_ids[_id] = {"subscribers" : [], "params" : []}
		return	
	
	if !event_ids[_id].has("subscribers"):
		event_ids[_id]["subscribers"] = []
	
	if !event_ids[_id].has("params"):
		event_ids[_id]["params"] = []
		
static func invoke_event(_id: String, _params := []) -> void: 
	create_event(_id)
	event_ids[_id]["params"] = _params

	for i in range((event_ids[_id]["subscribers"] as Array[EventListener]).size()):
		if event_ids[_id]["subscribers"][i].is_valid_listener: 
			event_ids[_id]["subscribers"][i].on_notify.call_deferred(_id)
		else: 
			remove_listener(event_ids[_id]["subscribers"][i], _id)
static func get_event_param(_id: String) -> Array[Variant]:
	create_event(_id)
	if (event_ids[_id]["params"] as Array).is_empty(): return [null]
	return event_ids[_id]["params"]

static var event_ids := {
		# ---- game events -----
		"STATE_PREGAME" : {},
		"STATE_PAUSE" : {},
		"STATE_ACTIVE" : {},
		
		"GAME_FILE_SAVE" : {},
		"GAME_CONFIG_SAVE" : {},
		
		# ---- reality states -----
		"REALITY_DREAM" : {},
		"REALITY_NEUTRAL" : {},
		
		# ---- cutscenes -----
		"CUTSCENE_START" : {},
		"CUTSCENE_END" : {},
		"CUTSCENE_START_REQUEST" : {},
		"CUTSCENE_END_REQUEST" : {},
		
		# ---- player ----
		"PLAYER_UPDATED" : {},
		
		"PLAYER_MOVE" : {},
		"PLAYER_EXHAUST" : {},
		"PLAYER_ACTION" : {},
		"PLAYER_EMOTE" : {},
		"PLAYER_INTERACT" : {},
		"PLAYER_HURT" : {},
		"PLAYER_STAMINA_CHANGE" : {},
		"PLAYER_WAKE_UP" : {},
		
		"PLAYER_EQUIP" : {},
		"PLAYER_DEEQUIP" : {},

		"PLAYER_EFFECT_FOUND" : {},
		"PLAYER_EFFECT_DISCARD" : {},
			
		"PLAYER_DOOR_TELEPORTATION" : {},
			
		"PLAYER_DOOR_USED" : {},
		"PLAYER_SANITY_CHANGE" : {},
		"PLAYER_ADRENALINE_CHANGE" : {},	

		# ---- chase events -----
		"PRECHASE_ACTIVE" : {},
		"PRECHASE_FINISH" : {},
		"CHASE_ACTIVE" : {},
		"CHASE_FINISH" : {},

		# ---- scene change invokes -----
		"SCENE_INITIALIZED" : {},
		"SCENE_LOADED" : {},
		"SCENE_UNLOADED" : {},
		"SCENE_CHANGE_REQUEST" : {},
		"SCENE_CHANGE_SUCCESS" : {},
		"SCENE_CHANGE_FAIL" : {},
		
		# ---- player special events ;; invert cutscene -----
		"SPECIAL_INVERT_START_REQUEST" : {},
		"SPECIAL_INVERT_END_REQUEST" : {},
		"SPECIAL_INVERT_CUTSCENE_BEGIN" : {},
		"SPECIAL_INVERT_CUTSCENE_END" : {},
		
		## WORLD.
		"WORLD_LOOP" : {},
		"WORLD_TIME_DAY" : {},
		"WORLD_TIME_NIGHT" : {},
	}
