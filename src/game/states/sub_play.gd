extends State

@export var dream_manager: FSM
@export var dream_manager_setup: bool = false

# - the player will be controlled from here.

var sentients: Array
var on_scene_change: EventListener

func _ready() -> void:
	on_scene_change = EventListener.new(["SCENE_CHANGE_SUCCESS"], false, self)
	on_scene_change.do_on_notify(["SCENE_CHANGE_SUCCESS"], func(): sentients = GlobalUtils.get_group_arr("sentients"))

func enter_state() -> void:
	sentients = GlobalUtils.get_group_arr("sentients")
	for s in sentients: if s != null: s._enter()
	
	
	print_rich("[color=yellow]GAME STATE:: = PLAY[/color]")
	if !dream_manager_setup:
		dream_manager_setup = true
		dream_manager._setup(self)
func exit_state() -> void:
	dream_manager_setup = false
	for s in sentients: if s != null: s._exit()


func update(_delta: float) -> void: 
	for s in sentients:
		if s != null: s._update(_delta)
func physics_update(_delta: float) -> void: 
	for s in sentients:
		if s != null: s._physics_update(_delta)
func input(event: InputEvent) -> void:
	for s in sentients:
		if s != null and s is Player: s._input_pass(event)
		
	if Input.is_action_just_pressed("esc_menu"): GameManager.pause_options(true)
	if Input.is_action_just_pressed("hud_toggle"):GameManager.set_ui_visibility(!GameManager.ui_parent.visible)
