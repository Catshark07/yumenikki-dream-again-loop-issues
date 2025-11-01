@tool

class_name ConditionalSequence
extends Sequence

@export var else_conditional: Sequence:
	set(_else):
		else_conditional = _else
		next = _else

func _ready() -> void:
	super()
	custom_linked_pointers = true
	
	if 	else_conditional == null:
		else_conditional = Utils.add_sibling_node(self, Sequence.new(), "else")
		else_conditional.skip = true
		next = else_conditional
		
	Utils.connect_to_signal(func(): else_conditional.name = "else_%s" % self.name, self.renamed)


func _predicate() -> bool:
	return true
	
func _validate() -> bool:
	if _predicate(): 	
		next = else_conditional.next
	else:			
		end()
		else_conditional.skip = false
		next = else_conditional
	
	return true
