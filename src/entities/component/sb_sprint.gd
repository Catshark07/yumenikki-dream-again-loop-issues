class_name SBSprint
extends SBComponent

@export var stamina_fsm: FSM

# - this component must be called in the RUN state instead.

func drain(_delta: float) -> void: 
	if sentient.values.disable_drain: return
	if sentient.stamina > 0: sentient.stamina -= (sentient.values.stamina_drain * _delta) 	

func _setup(_sb: SentientBase = null) -> void:
	super(_sb)
	stamina_fsm._setup(sentient) 		# --- fsm; not player dependency but required
func _physics_update(_delta: float) -> void: 
	stamina_fsm._physics_update(_delta)
	
	if sentient.stamina < 0:
		stamina_fsm.change_to_state("exhausted")
