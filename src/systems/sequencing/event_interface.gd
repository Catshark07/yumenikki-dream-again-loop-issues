@tool
class_name Event 
extends Node

signal finished
signal cancelled

# template pusherr line:
# printerr("EVENT - {NAME} :: {WARNING}!")

# -- 
const DEFAULT_EVENT = "res://src/systems/sequencing/objects/event_object.gd"

@export_storage var abstract_event: SequencerManager.EventObject:
	set = set_argument_dict
@export_file("*.gd") var abstract_event_script: String:
	set = create_abstract_event
@export var abstract_event_args: Dictionary

# --
@export_category("Event Flags.")
@export var wait_til_finished: 	bool = true
@export var skip: 				bool = false
@export var call_limit: int = 0 # - inclusive.

var call_count: int = 0
@export_category("Event Linked-Pointers.")
@export var custom_linked_pointers: bool = false
@export var prev: Node
@export var next: Node

var is_finished: bool = false
var is_active: bool = false

# - unfortunately not all events are allowed to skip their warnings as most 
# of em are really needed at some scenarios.

# -- initial
func _ready() -> void: 
	process_mode = Node.PROCESS_MODE_DISABLED

# -- virtual, override these.
func _execute	() -> void: pass
func _cancel	() -> void: pass
func _end		() -> void: pass

func _validate() -> bool: return true

# -- concrete implementations
func execute() -> void: 	
	is_finished = false
	is_active = true
	
	if call_limit > 0:
		call_count += 1
		
		# - first event call will have the "call_count" SET TO 1, NOT TO 0.
		if call_count > call_limit: 
			__call_finished.call_deferred()
			is_finished = true
			is_active = false
			return
		
		#if abstract_event: 
			#abstract_event._pass_args(abstract_event_args)
			#abstract_event._execute()
	
	if wait_til_finished: await _execute()
	else:						_execute()
	__call_finished.call_deferred()
	
	is_finished = true
	is_active = false
	
	print(self, " is finished!")

func cancel() -> void:
	_cancel()
	is_active = false
	is_finished = true
func end() -> void: 
	_end()
	is_active = false
	is_finished = true

# -- internal
func __call_finished() -> void:
	finished.emit()

func has_next() -> bool: return next != null
func has_prev() -> bool: return prev != null

# --
func _get_property_list() -> Array[Dictionary]:
	var properties: Array[Dictionary] = [{
		"name"			: "Event Object Arguments",
		"type"			: TYPE_NIL,
		"hint"			: PROPERTY_HINT_NONE,
		"hint_string"	: "",
		"usage" 		: PROPERTY_USAGE_CATEGORY}]
			
	if abstract_event != null: 
		for p in abstract_event.get_property_list():
			if  p["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE:
				p["usage"] |= PROPERTY_USAGE_EDITOR 
				properties.append(p)
	return properties

func _set(property: StringName, value: Variant) -> bool:
	if !abstract_event_args.is_empty():
		if  abstract_event_args.has(property):
			abstract_event_args[property] = value
	return false
	
func _get(property: StringName) -> Variant:
	if property in abstract_event_args: 
		return abstract_event_args[property]
	return

func create_abstract_event(_script_path: String) -> void:
	if abstract_event != null: abstract_event.free()
	abstract_event_script = _script_path
	
	if _script_path.is_empty() or \
		!ResourceLoader.exists(_script_path) or \
		abstract_event_script == DEFAULT_EVENT: 
			if abstract_event != null: abstract_event.free()
			return
			
	abstract_event = load(_script_path).new()
	
func set_argument_dict(_event: SequencerManager.EventObject) -> void:
	if _event != null:
		abstract_event = _event
	
	else:
		if abstract_event != null: abstract_event.free() 
		abstract_event_args = {}
		return
	
	for p in _event.get_property_list():
		if p["usage"] == PROPERTY_USAGE_SCRIPT_VARIABLE: abstract_event_args[p["name"]] = null
	
