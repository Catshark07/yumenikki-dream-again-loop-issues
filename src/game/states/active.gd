extends HFSM

var player_setup: bool = false

func _setup() -> void:
	super()
	if player_setup == false: 
		Player.Instance.setup()
		player_setup = true

func _enter_state() -> void:
	super()
	for s in GlobalUtils.get_group_arr("sentients"): 
		if s != null: s.unfreeze()
