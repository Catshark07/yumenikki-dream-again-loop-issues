class_name SceneNode
extends StackNode

var initialized: bool = false
var lonely: bool = true

func set_node_active(active: Node.ProcessMode) -> void:
	self.set_process_mode.call_deferred(active)

# - concrete
func _ready() -> void:
	self.add_to_group("scene_node")

func initialize() -> void: 
	if !initialized:
		lonely = false
		initialized = true
		_initialize()

# - virtual 
func _initialize() -> void: pass

func _on_pop() -> void:
	queue_free()
func _on_pre_pop() -> void: 
	set_node_active(Node.PROCESS_MODE_DISABLED)
func _on_push() -> void: 
	set_node_active(Node.PROCESS_MODE_INHERIT)

func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass
