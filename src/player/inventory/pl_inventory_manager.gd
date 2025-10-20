extends Component

@export var inventory: PLInventory

var effects: Array[PLEffect]
var data: Dictionary
var effect_acquired_listener: EventListener

func _setup() -> void:
	effect_acquired_listener = EventListener.new(self, "PLAYER_EFFECT_FOUND")
	effect_acquired_listener.do_on_notify( 
		func(): 
			add_item(EventManager.get_event_param("PLAYER_EFFECT_FOUND")[0]),
		"PLAYER_EFFECT_FOUND")

func update_inventory_array(_effects: Array[PLEffect]) -> void:
	for i in _effects:
		add_item(i)

func add_item(_effect: PLEffect) -> void:
	if _effect == null or _effect in effects: 
		print(_effect.resource_path, " DUPLICATE EFFECT")
		for i in effects:
			print(i.resource_path)
		return
	
	inventory.add_item(_effect)
	effects.append(_effect)
func remove_item(_effect: PLEffect) -> void:
	if _effect == null: return
	
	var effect_idx := effects.find(_effect)
	if effect_idx > -1: effects.remove_at(effect_idx)
	inventory.remove_item(_effect)
