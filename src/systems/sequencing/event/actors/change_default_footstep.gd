class_name EVN_ChangeDefaultFootstep
extends Event

@export var footstep_material: FootstepSet = Footstep.DEFAULT_FOOTSTEP_MAT
@onready var on_scene_unload := EventListener.new(self, "SCENE_CHANGE_REQUEST")

func _ready() -> void:
	on_scene_unload.do_on_notify(func():
		Footstep.default_footstep_mat = Footstep.DEFAULT_FOOTSTEP_MAT
		, "SCENE_CHANGE_REQUEST")
		
func _execute	() -> void:
	Footstep.default_footstep_mat = footstep_material
