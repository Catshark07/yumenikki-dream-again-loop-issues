class_name OnScreenVisible
extends VisibleOnScreenNotifier2D

@export var process_mode_on_enter: Node.ProcessMode = Node.PROCESS_MODE_INHERIT
@export var process_mode_on_exit: Node.ProcessMode 	= Node.PROCESS_MODE_INHERIT
@export var node: Node:
	set(_node):
		if _node != get_parent():
			node = _node

var visible_prior: bool = false

func _ready() -> void:	
	if node == null: return
	if node is CanvasItem: visible_prior = node.visible
	
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	if !Engine.is_editor_hint():
		Utils.connect_to_signal(_on_screen_enter, screen_entered)
		Utils.connect_to_signal(_on_screen_exit, screen_exited)

	_on_screen_exit()
func _on_screen_enter() -> void: 
	if node == null: return
	node.process_mode = process_mode_on_enter
	
	if visible_prior and (node is CanvasItem): node.visible = true
func _on_screen_exit() -> void:
	if node == null or !(node is CanvasItem): return
	node.process_mode = process_mode_on_exit
	node.visible = false
