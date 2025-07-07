@tool
extends GUIPanelButton

@export var time_played: Label
@export var effects_collected: Label

func _additional_setup() -> void:
	super()
	
	GlobalUtils.connect_to_signal(
		func(_data): update_data_info(_data), 
		abstract_button.unique_data_changed)

func update_data_info(_json_data: JSON) -> void:
	
	time_played.text = time_played.text % str(_json_data.data["game"]["time_played"])
	effects_collected.text = effects_collected.text % str(_json_data.data["player"]["effects"].size())
	
