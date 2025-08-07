@tool
 
class_name OnGameEvent
extends Sequence

@export var event_id: PackedStringArray
@export var sequence: Sequence
var listener: EventListener

func _ready() -> void: 
	super()
	listener = EventListener.new(event_id, false, self)
	
	if !Engine.is_editor_hint():
		listener.do_on_notify(event_id, execute)
