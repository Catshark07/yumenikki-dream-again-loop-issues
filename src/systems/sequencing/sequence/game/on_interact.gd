class_name OnInteract
extends Sequence

var interactable: Interactable

func _ready() -> void: 
	super()
	process_mode = Node.PROCESS_MODE_DISABLED	
	
	interactable = get_parent()
	if interactable == null or !(interactable is Interactable): return
	
	interactable.interacted.connect(func(): SequencerManager.invoke(self))
