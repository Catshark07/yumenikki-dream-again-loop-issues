extends Component

var chase_listener: EventListener

func _setup() -> void:
	chase_listener = EventListener.new(self, "CHASE_ACTIVE", "CHASE_FINISH")
	
	chase_listener.do_on_notify(
		func():
			Music.play_sound(preload("res://src/audio/bgm/chase.mp3")),
		"CHASE_ACTIVE")
	
	chase_listener.do_on_notify( 
		func(): Music.play_sound(
			Music.prev_music["stream"], 
			Music.prev_music["volume"], 
			Music.prev_music["pitch"], 
			Music.prev_music["carry_over"]),
		"CHASE_FINISH")
