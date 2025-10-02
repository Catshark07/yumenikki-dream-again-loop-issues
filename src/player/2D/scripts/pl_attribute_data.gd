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
@export var can_sprint: bool = Player.CAN_RUN
@export var auto_sprint: bool = false
@export var disable_drain: bool = false

@export_group("Noise Multipliers")
@export var walk_noise_mult: float = Player.WALK_NOISE_MULTI
@export var sneak_noise_mult: float = Player.SNEAK_NOISE_MULTI
@export var sprint_noise_mult: float = Player.SPRINT_NOISE_MULTI

func _apply(_pl: Player) -> void: 
	if !_pl.can_sprint: _pl.force_change_state("idle"
	)
	_pl.auto_sprint 		= self.auto_sprint
	_pl.walk_multiplier 	= self.walk_multi
	_pl.sprint_multiplier 	= self.sprint_multi
	_pl.sneak_multiplier 	= self.sneak_multi
	_pl.exhaust_multiplier 	= self.exhaust_multi
	
	_pl.stamina_drain 		= self.stamina_drain
	_pl.stamina_regen 		= self.stamina_regen
	_pl.can_sprint 			= self.can_sprint	
	
	_pl.walk_noise_mult 	= self.walk_noise_mult
	_pl.sneak_noise_mult 	= self.sneak_noise_mult
	_pl.sprint_noise_mult 	= self.sprint_noise_mult
func _unapply(_pl: Player) -> void: 
	_pl.auto_sprint 		= false
	_pl.walk_multiplier 	= Player.WALK_MULTI
	_pl.sprint_multiplier 	= Player.SPRINT_MULTI
	_pl.sneak_multiplier 	= Player.SNEAK_MULTI
	_pl.exhaust_multiplier 	= Player.EXHAUST_MULTI
	
	_pl.stamina_drain 		= Player.STAMINA_DRAIN
	_pl.stamina_regen		= Player.STAMINA_REGEN
	_pl.can_sprint 			= Player.CAN_RUN

	_pl.walk_noise_mult 	= Player.WALK_NOISE_MULTI
	_pl.sneak_noise_mult 	= Player.SNEAK_NOISE_MULTI
	_pl.sprint_noise_mult 	= Player.SPRINT_NOISE_MULTI
