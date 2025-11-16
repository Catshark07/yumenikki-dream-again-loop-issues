class_name EVN_SetAudioBusEffects
extends Event

@export var bus_name: String
@export var bus_effects: Array[AudioEffect]

func _execute() -> void:
	for fx in Audio.get_bus_effect_count(bus_name):
		Audio.remove_bus_effect(bus_name, fx)

	for fx in range(bus_effects.size()):
		if bus_effects[fx] == null: continue
		Audio.add_bus_effect(bus_name, bus_effects[fx], fx)
