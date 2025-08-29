extends SBState

@export var stance_fsm: SentientFSM
@export var sb_aggression: SBAggression
var target: SentientBase

func _state_enter() -> void:
	if sb_aggression.emits_chase_sequence:
		EventManager.invoke_event("CHASE_ACTIVE")
		
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(2, false)
	(sentient as NavSentient).nav_agent.set_navigation_layer_value(3, true)
	
	(sentient as NavSentient).nav_agent.target_desired_distance = 20.75
	sentient.handle_direction((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
	super()

func _state_exit() -> void:
	if sb_aggression.emits_chase_sequence:
		EventManager.invoke_event("CHASE_FINISH")

func physics_update(_delta: float) -> void: 
	if (sentient as NavSentient).nav_agent.is_target_reachable():
		
		sentient.handle_direction((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		sentient.handle_direction((sentient as NavSentient).nav_agent.get_next_path_position() - sentient.global_position)
		update_chase_point()
	
	else:
		stance_fsm.change_to_state("idle")
		update_chase_point()

func update(_delta: float) -> void:
	if sb_aggression.suspicion <= 50:
		sb_aggression.suspicion = 20
		fsm.change_to_state("observe")

func update_chase_point() -> void: 
	sentient.nav_agent.target_position = target.global_position
