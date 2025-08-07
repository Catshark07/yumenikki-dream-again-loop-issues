extends SentientState

@export var path_update_timer: Timer
@export var stance_fsm: SentientFSM
var target: SentientBase

func _enter_state() -> void: 
	if target == null: return
	(sentient as NavSentient).nav_agent.target_desired_distance = 32.5
	(sentient as NavSentient).nav_agent.target_position = target.global_position
	super()

func physics_update(_delta: float) -> void: 
	if target == null: return
	(sentient as NavSentient).nav_agent.target_position = target.global_position
	
	if (sentient as NavSentient).nav_agent.is_navigation_finished() or (sentient as NavSentient).nav_agent.is_target_reached():
		if stance_fsm == null: return
		stance_fsm.change_to_state("idle")
	else:
		(sentient as NavSentient).handle_direction((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.handle_direction((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
