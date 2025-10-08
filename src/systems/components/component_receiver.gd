@tool

class_name ComponentReceiver
extends Node

var components: Array
@export var affector: Node
@export var bypass: bool = false:
	set = set_bypass
@export var independent: bool = false

signal bypass_enabled
signal bypass_lifted

func _validate_property(property: Dictionary) -> void:
	if property.name == "affector" and independent:
		property.usage = PROPERTY_USAGE_NO_EDITOR

func _init(_affector: Node = null) -> void: 
	affector = _affector
func _ready() -> void: 
	if !Engine.is_editor_hint():
		components = get_children()
		set_independent(independent)
	
		if independent: _setup()

# -- if component receiver is independent.
func _process(delta: float) 		-> void: _update(delta)
func _physics_process(delta: float) -> void: _physics_update(delta)

# -- if component receiver is not independent.
func _setup() -> void: 
	for component in components: 
		if component and component is Component: 
			if component.invalid_setup: continue 
			component._setup()	
func _update(_delta: float) -> void:
	if bypass: return
	for component in components: 
		if component != null and component is Component: 
			if component.invalid_update: continue
			component._update(_delta)
func _physics_update(_delta: float) -> void: 
	if bypass: return
	for component in components: 
		if component != null and component is Component:
			if component.invalid_physics_update: continue 
			component._physics_update(_delta)

func set_independent(_independ: bool) -> void:
	match _independ:
		true: 
			set_process(true)
			set_physics_process(true)
		false: 
			set_process(false)
			set_physics_process(false)
func set_bypass(_by: bool) -> void: 
	bypass = _by
	if _by: bypass_enabled.emit()
	else: bypass_lifted.emit()
	
func get_component_by_name(_name: String) -> Component:
	for i in get_children():
		if i and i.name == _name:
			return i
			
	return null
func has_component_by_name(_name: String) -> bool:
	for i in get_children():
		if i != null and i is Component and  i.name == _name: return true
	return false
func add_component(_comp: Component) -> void: pass
