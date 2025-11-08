class_name OnScreenNotifier
extends VisibleOnScreenNotifier2D

@export var process_mode_enabling: Node.ProcessMode = Node.PROCESS_MODE_INHERIT
var node: Node

func _ready() -> void:	
	node = get_parent()
	process_mode = Node.PROCESS_MODE_PAUSABLE
	
	# idk why the fuck this thing is getting called thru Utils.add_child.
	# bail if its editor.
	if Engine.is_editor_hint(): return 

	Utils.connect_to_signal(_on_screen_enter, screen_entered)
	Utils.connect_to_signal(_on_screen_exit, screen_exited)

	await RenderingServer.frame_post_draw
	
func _on_screen_enter() -> void: 
	if node == null: return
	node.process_mode = process_mode_enabling
func _on_screen_exit() -> void:
	if node == null: return
	node.process_mode = Node.PROCESS_MODE_DISABLED
