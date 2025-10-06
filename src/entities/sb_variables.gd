class_name SBVariables
extends Resource

@export_group("Speed & Multipliers")
@export var walk_multi: 	float = SentientBase.WALK_MULTI
@export var sprint_multi: 	float = SentientBase.SPRINT_MULTI
@export var sneak_multi: 	float = SentientBase.SNEAK_MULTI

@export_group("Stats Flags.")
@export var can_sprint: 	bool = true
@export var can_sneak: 		bool = true
@export var auto_sprint: 	bool = false

@export_group("Noise Multipliers")
@export var walk_noise_multi: 		float = SentientBase.WALK_NOISE_MULTI
@export var sneak_noise_multi: 		float = SentientBase.SNEAK_NOISE_MULTI
@export var sprint_noise_multi: 	float = SentientBase.SPRINT_NOISE_MULTI
