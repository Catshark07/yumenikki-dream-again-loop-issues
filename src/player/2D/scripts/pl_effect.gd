class_name PLEffect
extends Resource

@export_group("Information")
@export var name: String = ""
@export var desc: String = ""
@export var icon: Texture2D

@export var skip_equip_animation: bool 		= false
@export var skip_deequip_animation: bool 	= false

var use_times: int = 0

@export_group("Attributes")
@export var decorator: PLAttributeData 	= preload("res://src/player/2D/madotsuki/effects/_none/_stats.tres")
@export var behaviour: PLBehaviour		= preload("res://src/player/2D/madotsuki/effects/_none/_behaviour.tres")

@export_group("Display")
@export_file("*.tres") var sprite_override: String 	= ("res://src/player/2D/madotsuki/display/no_effect.tres")
@export_file("*.tres") var emote: String 			= ("res://src/player/2D/madotsuki/emotes/sit_down.tres")

@export_file("*.tscn") var player_component_prefab: String
var player_component: Node

func _apply(_pl: Player) -> void:
	
	if !emote.is_empty() and load(emote): 
		(_pl as Player_YN).components.get_component_by_name(Player_YN.COMP_ACTION).set_emote(load(emote))
	
	if 	( 
		!player_component_prefab.is_empty() and
		ResourceLoader.exists(player_component_prefab) and 
		load(player_component_prefab).can_instantiate()):
			
			var prefab_instance: PLEffectComponent = load(player_component_prefab).instantiate()
			
			prefab_instance.name = "effect" + self.name
			prefab_instance.effect_data = self
			
			_pl.components.get_component_by_name(Player_YN.COMP_EQUIP).effect_prefab = prefab_instance 			
			_pl.components.get_component_by_name(Player_YN.COMP_EQUIP).add_child(
				_pl.components.get_component_by_name(Player_YN.COMP_EQUIP).effect_prefab)
			
			prefab_instance._enter(_pl)
	
	behaviour._apply(_pl)
	
	if load(sprite_override): 
		(_pl as Player_YN).set_sprite_sheet(load(sprite_override))

func _unapply(_pl: Player) -> void:
	(_pl as Player_YN).cancel_action(
		(_pl as Player_YN).components.get_component_by_name(Player_YN.COMP_ACTION).curr_action)
	(_pl as Player_YN).components.get_component_by_name(Player_YN.COMP_ACTION).set_primary_action(null)
	(_pl as Player_YN).components.get_component_by_name(Player_YN.COMP_ACTION).set_secondary_action(null)
	(_pl as Player_YN).components.get_component_by_name(Player_YN.COMP_ACTION).set_emote(null)
	
	behaviour._unapply(_pl)
	
	(_pl as Player_YN).set_sprite_sheet(load(Player.Instance.DEFAULT_EQUIPMENT.sprite_override))
	
func _primary_use(_pl: Player) 		-> void: pass
func _secondary_use(_pl: Player) 	-> void: pass

# ---- misc. getters.
