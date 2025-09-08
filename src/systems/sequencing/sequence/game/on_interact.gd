class_name OnInteract
extends Sequence

var interactable: Node

func _ready() -> void: 
	super()
	process_mode = Node.PROCESS_MODE_DISABLED	
	
	interactable = get_parent()
	if interactable == null or !(interactable is Interactable): return
	
	(interactable as Interactable).interacted.connect(func(): SequencerManager.invoke(self))
