class_name NavSentient
extends SentientBase

@export var nav_agent: NavigationAgent2D
@export var stance_fsm: SentientFSM
@export var behaviour_fsm: SentientFSM

var sound_player: SoundPlayer

func _ready() -> void:
	super()

func dependency_setup() -> void: 
	stance_fsm._setup(self)
	behaviour_fsm._setup(self)
	sound_player = get_node("sound_player")
	
func _update(_delta: float) -> void:
	super(_delta)
	stance_fsm._update(_delta)
	behaviour_fsm._update(_delta)

func _physics_update(_delta: float) -> void:
	super(_delta)
	stance_fsm._physics_update(_delta)
	behaviour_fsm._physics_update(_delta)
