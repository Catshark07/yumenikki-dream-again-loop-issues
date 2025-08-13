@tool

class_name PanoramaPlaceholder
extends Node

func _ready() -> void: 
	if Engine.is_editor_hint(): return
	GlobalUtils.connect_to_signal(apply_panorama, Game.scene_loaded, ConnectFlags.CONNECT_ONE_SHOT)
	GlobalUtils.connect_to_signal(remove_panorama, Game.scene_unloaded, ConnectFlags.CONNECT_ONE_SHOT)
	
func apply_panorama() -> void:
	if Engine.is_editor_hint():
		
		if (self as Node) is SubViewport:
			self.default_texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			self.default_texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
			self.size = Vector2(480, 270)
	
		if (self as Node) is Control:
			self.global_position = Vector2.ZERO
			self.custom_minimum_size = Vector2(480, 270)
	
	if !Engine.is_editor_hint():
		PanoramaSystem.instance.apply_panorama(self)

func remove_panorama() -> void:
	PanoramaSystem.instance.remove_panorama()
	
