extends State

func _enter_state() -> void:
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s.freeze()
		
func _exit_state() -> void:
	for s in GlobalUtils.get_group_arr("actors"): 
		if s != null: s.unfreeze()
