class_name PLEffectComponent
extends Node

var effect_data: 				PLEffect

# ---- 	DO NOT TOUCH THESE 	----
func _enter	(_pl: Player) -> void: pass
func _exit	(_pl: Player) -> void: pass

# -
func _eff_physics_update	(_delta: float, _pl: Player) 		-> void: pass
func _eff_update			(_delta: float, _pl: Player) 		-> void: pass
func _eff_input				(_input: InputEvent, _pl: Player) 	-> void: pass

# -
func _primary	(_pl: Player) -> void: pass
func _secondary	(_pl: Player) -> void: pass
