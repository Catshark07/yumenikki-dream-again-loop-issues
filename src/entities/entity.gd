class_name Entity
extends Node2D

var height: float = 0

func freeze() -> void: process_mode = Node.PROCESS_MODE_DISABLED
func unfreeze() -> void: process_mode = Node.PROCESS_MODE_INHERIT
