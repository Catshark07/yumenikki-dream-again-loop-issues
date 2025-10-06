class_name PLAttributeData
extends Resource

@export_group("Speed & Multipliers")
@export var walk_multi: float = Player.WALK_MULTI
@export var sprint_multi: float = Player.SPRINT_MULTI
@export var sneak_multi: float = Player.SNEAK_MULTI
@export var exhaust_multi: float = Player.EXHAUST_MULTI

@export_group("Stamina Modifers")
@export var stamina_drain: float = Player.STAMINA_DRAIN
@export var stamina_regen: float = Player.STAMINA_REGEN

@export_group("Stats Flags.")
@export var can_sprint: bool = Player.CAN_SPRINT
@export var auto_sprint: bool = false
@export var disable_drain: bool = false

@export_group("Noise Multipliers")
@export var walk_noise_mult: float = Player.WALK_NOISE_MULTI
@export var sneak_noise_mult: float = Player.SNEAK_NOISE_MULTI
@export var sprint_noise_mult: float = Player.SPRINT_NOISE_MULTI
