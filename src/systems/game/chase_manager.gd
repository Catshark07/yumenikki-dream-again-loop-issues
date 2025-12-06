extends Component

var chase_listener: EventListener

func _setup() -> void:
	chase_listener = EventListener.new(self, "CHASE_ACTIVE", "CHASE_FINISH")
	
