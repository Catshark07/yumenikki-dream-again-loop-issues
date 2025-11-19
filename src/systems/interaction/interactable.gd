@tool

class_name Interactable
extends AreaRegion

@export_group("Flags")
@export var secret: 		bool = false
@export var only_once: 		bool = false
@export var can_interact: 	bool = true

@export_group("Area Triggers")
@export var area: 			bool = false:
	set(_a): 
		area = _a
		if centre_trigger: 	set_collision_mask_value(32, _a)
		else:				set_collision_mask_value(31, _a)
@export var centre_trigger:	bool = false:
	set(_centre):
		centre_trigger = _centre
		if _centre and area: 	
			set_collision_mask_value(31, false)
			set_collision_mask_value(32, true)
		elif area: 					
			set_collision_mask_value(31, true)
			set_collision_mask_value(32, false)
# - signals
signal interacted
signal fail
signal success

func _ready() -> void:	
	super() 
	
func _setup() -> void:
	set_physics_process(false)
	set_process(false)

func interact() -> void:
	if only_once and can_interact:
		can_interact = false
		_interact()
		interacted.emit()
		
	elif can_interact:
		_interact()
		interacted.emit()
func _interact() -> void: pass

func _handle_player_enter() -> void: if area: 
	self.interact()
