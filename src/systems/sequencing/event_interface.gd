class_name Event extends Node
signal finished

# template pusherr line:
# printerr("EVENT - {NAME} :: {WARNING}!")

@export_category("Event Flags.")
@export var deferred: bool = true
@export var wait_til_finished: bool = true
@export var skip_warning: bool = false

var call_count: int = 0
@export var call_limit: int = 0 # - inclusive.

# - unfortunately not all events are allowed to skip their warnings as most 
# of em are really needed at some scenarios.

# -- initial
func _ready() -> void: process_mode = Node.PROCESS_MODE_DISABLED

# -- virtual, override these.
func _execute() -> void: pass
func _end() -> void: pass
func _validate() -> bool:
	return true

# -- concrete
func execute() -> void: 
	if call_limit > 0:
		call_count += 1
		if call_count > call_limit: return

	await _execute()
	if deferred: finished.emit.call_deferred()
	else:		 finished.emit()
func end() -> void: 
	_end()
