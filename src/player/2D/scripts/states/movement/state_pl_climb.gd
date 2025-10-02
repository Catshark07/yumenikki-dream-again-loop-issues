extends SBState

var progress: float
var heading: float

func _state_enter() -> void: 
	sentient.animation_manager.anim_state.start("walk")
func _state_exit() -> void:
	sentient.animation_manager.anim_state.stop()
	
func _state_update(_delta: float, ) -> void:
	
	sentient.animation_manager.update(sentient, _delta)
	sentient.animation_manager.anim_tree.set("parameters/tree/time_scale/scale", sentient.speed / sentient.max_speed)
	
func _state_physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._climb(sentient)
