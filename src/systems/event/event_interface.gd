class_name Event extends Node
signal finished

# template pusherr line:
# printerr("EVENT - PLAYSOUND :: Sound is null!")

@export var deferred: bool = true
@export var wait_til_finished: bool = true
@export var skip_warning: bool = false

# - unfortunately not all events are allowed to skip their warnings as most 
# of em are really needed at some scenarios.

# ---- virtual, concrete ----
func _ready() -> void: process_mode = Node.PROCESS_MODE_DISABLED
func _execute() -> void: 
	if deferred: finished.emit.call_deferred()
	else:		 finished.emit()


func _validate() -> bool:
	return true
