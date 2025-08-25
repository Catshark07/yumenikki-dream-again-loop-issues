extends SBState

var progress: float
var heading: float

func _enter_state() -> void: 
	sentient.animation_manager.anim_state.start("walk")
func _exit_state() -> void:
	sentient.animation_manager.anim_state.stop()
	
func update(_delta: float, ) -> void:
	
	sentient.animation_manager.update(sentient, _delta)
	sentient.animation_manager.anim_tree.set("parameters/tree/time_scale/scale", sentient.speed / sentient.max_speed)
	
func physics_update(_delta: float, ) -> void:
	sentient.get_behaviour()._climb(sentient)
	sentient.handle_velocity()
