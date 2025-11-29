class_name OnScreenNotifier
extends VisibleOnScreenNotifier2D

@export var process_mode_enabling: Node.ProcessMode = Node.PROCESS_MODE_INHERIT
var node: Node
var visible_prior: bool = false

func _ready() -> void:	
	if node == null or self in node.get_children(): return
	visible_prior = node.visibility if node is CanvasItem else false
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if Engine.is_editor_hint(): return 

	Utils.connect_to_signal(_on_screen_enter, screen_entered)
	Utils.connect_to_signal(_on_screen_exit, screen_exited)

func _on_screen_enter() -> void: 
	if node == null: return
	node.process_mode = process_mode_enabling
	if node is CanvasItem and visible_prior: node.visible = true
func _on_screen_exit() -> void:
	if node == null: return
	node.process_mode = Node.PROCESS_MODE_DISABLED
	if node is CanvasItem: node.visible = false
