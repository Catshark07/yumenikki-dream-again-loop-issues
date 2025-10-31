class_name SceneNode
extends StackNode

var initialized: 	bool = false
var pushed:			bool = false
var lonely: 		bool = true

signal about_to_free
signal freed
signal entered

func set_node_active(active: Node.ProcessMode) -> void:
	self.set_process_mode.call_deferred(active)

# - concrete
func _ready() -> void:
	if pushed: return
	pushed = true
	
	Utils.u_add_to_group(self, "scene_node")
	EventManager.invoke_event("SCENE_TREE_ENTERED", self)

func initialize() -> void: 
	if !initialized:
		lonely = false
		initialized = true
		_initialize()

# - virtual 
func _initialize() -> void: pass

func _on_pop() -> void:
	freed.emit()
	queue_free()
func _on_pre_pop() -> void: 
	about_to_free.emit()
	set_node_active(Node.PROCESS_MODE_DISABLED)
func _on_push() -> void: 
	entered.emit()
	set_node_active(Node.PROCESS_MODE_INHERIT)

func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass
