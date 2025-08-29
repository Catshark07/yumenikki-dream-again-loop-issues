extends Event

enum flag {SCENE, GLOBAL}
@export var flag_type: flag = flag.SCENE

func _execute() -> void: print(owner)
	
