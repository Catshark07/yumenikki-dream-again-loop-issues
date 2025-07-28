class_name SCH_DEBUG
extends InputManager.Scheme


var print_command_1: Command
var print_command_2: Command
var print_command_3: Command
	
func _init(_binds: InputManager.Keybind) -> void:
	super(_binds)

	print_command_1 = CMD_PRINT.new()
	print_command_2 = CMD_PRINT.new()
	print_command_3 = CMD_PRINT.new()

	command_dict[print_command_1] = "move_right"
	command_dict[print_command_2] = "move_up"
	command_dict[print_command_3] = "move_down"

class CMD_PRINT:
	extends Command
	
	func _execute(args = []) -> void: print(self, "fuck")
