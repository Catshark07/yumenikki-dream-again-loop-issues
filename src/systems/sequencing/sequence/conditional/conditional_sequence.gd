@tool

class_name ConditionalSequence
extends Sequence

@export var else_conditional: Sequence

func _ready() -> void:
	super()
	custom_linked_pointers = true
	
	if 	else_conditional == null:
		else_conditional = Utils.add_sibling_node(self, Sequence.new(), "else")
		else_conditional.skip = true
		next = else_conditional
		
	Utils.connect_to_signal(func(): else_conditional.name = "else_%s" % self.name, self.renamed)

func _execute() -> void:
	if _predicate(): 
		super()
	else:
		else_conditional.skip = false

func _predicate() -> bool:
	return true
