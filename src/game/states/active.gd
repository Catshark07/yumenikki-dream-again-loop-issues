extends HFSM

var player_setup: bool = false

func _setup() -> void:
	super()
	Player.Instance.setup()
