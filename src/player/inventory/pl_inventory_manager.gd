extends Component

@export var inventory: PLInventory

var effects: Array = []
var data: Dictionary
var data_save_listener: EventListener

func _setup() -> void:
	data_save_listener = EventListener.new(["GAME_FILE_SAVE"], false, self) 
	data_save_listener.do_on_notify(
		["GAME_FILE_SAVE"], 
		print.bind(EventManager.get_event_param("GAME_FILE_SAVE")[0]))
		
	ResourceSaver.save(
		load("res://src/player/2D/madotsuki/effects/bike/bike.tres"), 
		str(Save.SAVE_DIR, "save_effect_%s.res" % [0]))

func update_inventory_array(_effects: Array[PLEffect]) -> void:
	for i in _effects:
		add_item(i)

func add_item(_effect: PLEffect) -> void:
	if _effect == null: return
	
	inventory.add_item(_effect)
	Player.Data.effects.append(_effect)
func remove_item(_effect: PLEffect) -> void:
	if _effect == null: return
	
	var effect_idx := Player.Data.effects.find(_effect)
	if effect_idx > -1: Player.Data.effects.remove_at(effect_idx)
	inventory.remove_item(_effect)
