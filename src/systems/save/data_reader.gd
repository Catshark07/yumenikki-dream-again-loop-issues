extends Node

func change_data_value(_key: String, _val: Variant) -> void:
	if !_key in data: return
	data[_key] = _val 
func read_data_value(_key: String) -> Variant:
	if !_key in data: return
	return data[_key]
