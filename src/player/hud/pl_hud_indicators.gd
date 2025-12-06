extends Control

@export var effect_ind: SpriteSheetFormatter
@export var stamina_bar: ColorRect

var effect_equip: EventListener
var pl_stamina_change: EventListener

func _ready() -> void:
	var stamina_bar_size_x := stamina_bar.size.x
	
	effect_equip = EventListener.new(self, "PLAYER_EQUIP", "PLAYER_DEEQUIP")
	effect_equip.do_on_notify(func(): 
		if EventManager.get_event_param("PLAYER_EQUIP")[0] != Player.Instance.DEFAULT_EQUIPMENT: 
			effect_ind.progress = 1,
			"PLAYER_EQUIP")
	effect_equip.do_on_notify(func(): effect_ind.progress = 0, "PLAYER_DEEQUIP")
	
	pl_stamina_change = EventListener.new(self, "PLAYER_STAMINA_CHANGE", "PLAYER_UPDATED")
	pl_stamina_change.do_on_notify(
		func():
			if Player.Instance.get_pl() != null:
				stamina_bar.size.x = stamina_bar_size_x * \
				Player.Instance.get_pl().stamina / Player.MAX_STAMINA,
			"PLAYER_STAMINA_CHANGE", "PLAYER_UPDATED")

		
