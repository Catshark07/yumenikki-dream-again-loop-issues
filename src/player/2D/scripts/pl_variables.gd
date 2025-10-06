class_name PLVariables
extends SBVariables

@export_group("Player Exclusive")
@export_subgroup("Stamina-related Variables")
@export var exhaust_multi: float = Player.EXHAUST_MULTI
@export var stamina_drain: float = Player.STAMINA_DRAIN
@export var stamina_regen: float = Player.STAMINA_REGEN
@export var disable_drain: bool = false

@export_subgroup("Display")
@export_file("*.tres") var sprite_override: String 	= ("res://src/player/2D/madotsuki/display/no_effect.tres")
@export_file("*.tres") var emote: String 			= ("res://src/player/2D/madotsuki/emotes/sit_down.tres")
