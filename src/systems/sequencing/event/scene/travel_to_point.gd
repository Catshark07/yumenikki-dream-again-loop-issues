extends Event

@export var target_point: SpawnPoint

func _execute() -> void:
	EventManager.invoke_event("PLAYER_DOOR_TELEPORTATION")
	Player.Instance.teleport_player(target_point.global_position, target_point.spawn_dir)
	Player.Instance.get_pl().reparent(target_point.parent_instead_of_self)
	super()

func _validate() -> bool:
	return target_point != null
