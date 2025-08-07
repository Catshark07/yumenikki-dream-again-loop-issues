@tool

class_name PanoramaPlaceholder
extends Node

func _ready() -> void: 
	if Engine.is_editor_hint():
		if (self as Node) is SubViewport:
			self.default_texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			self.default_texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
			self.size = Vector2(480, 270)
	
	if !Engine.is_editor_hint():
		PanoramaSystem.instance.apply_panorama(self)
