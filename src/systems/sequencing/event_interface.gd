class_name Event extends Node

signal finished
signal canceled

# template pusherr line:
# printerr("EVENT - {NAME} :: {WARNING}!")

@export_category("Event Flags.")
@export var deferred: bool = true
@export var wait_til_finished: bool = true
@export var skip: bool = false

var call_count: int = 0
var next: Event
var prev: Event
@export var call_limit: int = 0 # - inclusive.

# - unfortunately not all events are allowed to skip their warnings as most 
# of em are really needed at some scenarios.

# -- initial
func _ready() -> void: process_mode = Node.PROCESS_MODE_DISABLED

# -- virtual, override these.
func _cancel() -> void: pass
func _execute() -> void: pass
func _end() -> void: pass

func _validate() -> bool: return true

# -- concrete implementations
func execute() -> void: 
	if call_limit > 0:
		call_count += 1
		if call_count > call_limit: return
	
	# - first event call will have the "call_count" SET TO 1, NOT TO 0.
	
	if !wait_til_finished: 	__call_finished() 
	await _execute()
	if wait_til_finished: 	__call_finished()
func cancel() -> void:
	_cancel()
	canceled.emit.call_deferred()
func end() -> void: 
	_end()

# -- internal
func __call_finished() -> void:
	if deferred: finished.emit.call_deferred()
	else:		 finished.emit()
func __get_next() -> Event: return next 
func __get_prev() -> Event: return prev
