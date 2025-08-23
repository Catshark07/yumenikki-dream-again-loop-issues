extends State
	
@export var inventory: PLInventory

func _setup() -> void:
	inventory._setup()

func _enter_state() -> void: 
	Ambience.mute()
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 300)
	
	Game.lerp_timescale(0.5)
	GameManager.set_cinematic_bars(true)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_BEGIN")
	SceneManager.scene_node.process_mode = Node.PROCESS_MODE_DISABLED
	
	inventory.visible = true
	if inventory != null: inventory._enter()
func _exit_state() -> void: 	
	Ambience.unmute()
	Audio.adjust_bus_effect("Distorted", 1, "cutoff_hz", 16000)
	
	Game.lerp_timescale(1)
	GameManager.set_cinematic_bars(false)
	EventManager.invoke_event("SPECIAL_INVERT_CUTSCENE_END")
	SceneManager.scene_node.process_mode = Node.PROCESS_MODE_INHERIT
	
	inventory.visible = false
	if inventory != null: inventory._exit()

func input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("pl_inventory"): 
		EventManager.invoke_event("SPECIAL_INVERT_END_REQUEST")
