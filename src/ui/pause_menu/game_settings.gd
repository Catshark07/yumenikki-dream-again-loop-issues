class_name IngameSettings
extends Control

var initial_hidden_stack_arr: Array
var initial_active_stack_arr: Array

var hidden_stack: Stack
var active_stack: Stack

@export var hidden_nodes: Node
@export var active_nodes: Node

var game_selection_dict := {
	0 :
}

func _ready() -> void: 
	hidden_stack = Stack.new()
	active_stack = Stack.new()
	
	hidden_stack.popped.connect(hidden_nodes.add_child)
	active_stack.popped.connect(active_nodes.add_child)
	
	for i in hidden_nodes.get_children(): hidden_stack.push(i)
	initial_hidden_stack_arr = hidden_stack.array
	initial_active_stack_arr = active_stack.array
	
	active_stack.push(hidden_stack.pop())
