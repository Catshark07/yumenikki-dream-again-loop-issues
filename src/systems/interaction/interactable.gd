@tool

class_name Interactable
extends AreaRegion

@export_group("Flags")
@export var secret: 		bool = false
@export var area: 			bool = false
@export var only_once: 		bool = false
@export var can_interact: 	bool = true

# - signals
signal interacted
signal fail
signal success

func _ready() -> void:	
	super() 
	
	if !Engine.is_editor_hint():
		self.set_collision_layer_value(2, true)
		self.set_collision_mask_value(3, true)
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

func _handle_player_enter() -> void: if area: self.interact()
