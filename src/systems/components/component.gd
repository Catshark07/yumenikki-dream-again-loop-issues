class_name Component extends Node


''' 
-- Component Class 101 -- 
	the component node will act as a child of a node.
	it will override or add new features to that node.
	the node in question will be the parent that it is a child of.

-- Target Node Info. -- 
	the target node will be of type node.
	in the concrete classes of "component", we can use assert to ensure-
	-that the component works with certain types of nodes.
'''

var invalid_setup: bool = false
var invalid_update: bool = false
var invalid_physics_update: bool = false

@export var receiver: ComponentReceiver
@export var active: bool = true:
	set(_a): 
		active = _a
		set_active(_a)

func _ready() -> void: 
	if receiver != null: return
	if get_parent() is ComponentReceiver: 
		receiver = get_parent()

		Utils.connect_to_signal(_on_bypass_enabled, receiver.bypass_enabled)
		Utils.connect_to_signal(_on_bypass_lifted, receiver.bypass_lifted)
		
# ---- component functions ----
func set_active(_active: bool = true) -> void:
	match _active:
		false: process_mode = Node.PROCESS_MODE_DISABLED
		true: process_mode = Node.PROCESS_MODE_INHERIT

# ---- node functions ----
func _setup() -> void: pass
	
# ---- virtual functions ----
func _execute() -> void: pass
func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass

func _on_bypass_enabled() -> void: pass
func _on_bypass_lifted() -> void: pass
