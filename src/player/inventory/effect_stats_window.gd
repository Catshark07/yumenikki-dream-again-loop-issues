extends Control

var player: Player

@export var walk_speed: Control
@export var sprint_speed: Control
@export var sneak_speed: Control
@export var exhaust_speed: Control

@export var can_run: Control
@export var stamina_regen: Control
@export var stamina_decay: Control

@onready var default_player_stats 		:= load("res://src/player/2D/madotsuki/effects/_none/_default.tres")
@onready var stats_neutral_indicator 	:= load("res://src/player/inventory/stats_neutral.png")
@onready var stats_positive_indicator 	:= load("res://src/player/inventory/stats_positive.png")
@onready var stats_negative_indicator 	:= load("res://src/player/inventory/stats_negative.png")

var player_stats_changed: EventListener

func _ready() -> void:
	player_stats_changed = EventListener.new(self, "PLAYER_EQUIP", "PLAYER_DEEQUIP")
	player_stats_changed.do_on_notify(
		func(): 
			update_stats_display(EventManager.get_event_param("PLAYER_EQUIP")[0]),
		"PLAYER_EQUIP")
	player_stats_changed.do_on_notify(
		func(): 
			update_stats_display(default_player_stats),
		"PLAYER_DEEQUIP") 

func update_stats_display(_effect: PLEffect) -> void:
	handle_stats_display_value(walk_speed, "WALK SPEED: %.2f m/s" % 		(_effect.decorator.walk_multi * SentientBase.BASE_SPEED / 16))
	handle_stats_display_value(sprint_speed, "SPRINT SPEED: %.2f m/s" % 	(_effect.decorator.sprint_multi * SentientBase.BASE_SPEED / 16))
	handle_stats_display_value(sneak_speed, "SNEAK SPEED: %.2f m/s" % 		(_effect.decorator.sneak_multi * SentientBase.BASE_SPEED / 16))
	handle_stats_display_value(exhaust_speed, "EXHAUST SPEED: %.2f m/s" % 	(_effect.decorator.exhaust_multi * SentientBase.BASE_SPEED / 16))
	
	handle_stats_display_value(can_run, "CAN RUN?: %s" 						% _effect.decorator.can_run)
	handle_stats_display_value(stamina_regen, "STAMINA REGEN: +%.2f stam/s" % _effect.decorator.stamina_regen)
	handle_stats_display_value(stamina_decay, "STAMINA DRAIN: -%.2f stam/s" % _effect.decorator.stamina_drain)
	
	handle_stats_display_improvement(walk_speed, _effect.decorator.walk_multi, default_player_stats.decorator.walk_multi)
	handle_stats_display_improvement(sprint_speed, _effect.decorator.sprint_multi, default_player_stats.decorator.sprint_multi)
	handle_stats_display_improvement(sneak_speed, _effect.decorator.sneak_multi, default_player_stats.decorator.sneak_multi)
	handle_stats_display_improvement(exhaust_speed, _effect.decorator.exhaust_multi, default_player_stats.decorator.exhaust_multi)
			
	handle_stats_display_improvement(can_run, _effect.decorator.can_run, default_player_stats.decorator.can_run)
	handle_stats_display_improvement(stamina_regen, _effect.decorator.stamina_regen, default_player_stats.decorator.stamina_regen)
	handle_stats_display_improvement(stamina_decay, -_effect.decorator.stamina_drain, -default_player_stats.decorator.stamina_drain)
				

func handle_stats_display_value(_stat: Control, _text: String) -> void:
	if _stat.has_node("text"): _stat.get_node("text").text = str(_text)
	else: return
func handle_stats_display_improvement(_stat: Control, _value: float, _to_compare: float) -> void:
	if _stat.has_node("icon") and _stat.has_node("text"):
		if _value == _to_compare: 
			_stat.get_node("icon").texture = stats_neutral_indicator
			_stat.get_node("text").self_modulate = Color.WHITE
		elif _value > _to_compare: 
			_stat.get_node("icon").texture = stats_positive_indicator
			_stat.get_node("text").self_modulate = Color.GREEN_YELLOW
		elif _value < _to_compare: 
			_stat.get_node("icon").texture = stats_negative_indicator
			_stat.get_node("text").self_modulate = Color.RED
