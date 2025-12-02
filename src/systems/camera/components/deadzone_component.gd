extends Component

var deadzone_stack: Stack
var curr_deadzone: CamDeadzone

signal update_curr_deadzone

func _setup() -> void:
	deadzone_stack = Stack.new()
	update_curr_deadzone.connect(func(): curr_deadzone = deadzone_stack.top)
	
func __push_dz(_dz: CamDeadzone) -> void:
	deadzone_stack.push(_dz)
	update_curr_deadzone.emit()
func __pop_dz() -> void:
	deadzone_stack.pop()
	update_curr_deadzone.emit()

func _update(delta: float) -> void:
	if curr_deadzone != null:
		receiver.affector.global_position = receiver.affector.global_position.clamp(
			curr_deadzone.get_min_clamp_pos(), curr_deadzone.get_max_clamp_pos())
