extends ConditionalSequence


@export var heading_condition: SentientBase.compass_headings
@export var minimum_speed: float = 10

func _predicate() -> bool:
	var player = Player.Instance.get_pl()
	if player == null: return false
	return player.desired_speed >= minimum_speed and player.heading == heading_condition  
