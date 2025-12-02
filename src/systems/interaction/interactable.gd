@tool

class_name Interactable
extends AreaRegion

@export_group("Flags")
@export var secret: 		bool = false
@export var only_once: 		bool = false
@export var can_interact: 	bool = true:
	set(_can_interact): 
		can_interact = _can_interact
		set_collision_layer_value(2, _can_interact)

@export var area: 			bool = true
@export_group("Area Triggers")
@export var area_trgger: 	bool = false:
	set(_trigger):
		area_trgger = _trigger
		if area: 	
			set_collision_mask_value(32, false)
			set_collision_mask_value(31, _trigger)
@export var centre_trigger:	bool = false:
	set(_trigger):
		centre_trigger = _trigger
		if area: 	
			set_collision_mask_value(31, false)
			set_collision_mask_value(32, _trigger)

# - signals
signal interacted
signal fail
signal success

func _ready() -> void:	
	super() 
	set_collision_layer_value(2, can_interact)
	set_collision_mask_value(30, false)
	
func _setup() -> void:
	set_physics_process	(false)
	set_process			(false)

func interact() -> void:
	if only_once and can_interact:
		can_interact = false
		_interact()
		interacted.emit()
		
	elif can_interact:
		_interact()
		interacted.emit()
func _interact() -> void: pass

func _handle_player_enter() -> void: 
	if area_trgger or centre_trigger: 
		self.interact()
