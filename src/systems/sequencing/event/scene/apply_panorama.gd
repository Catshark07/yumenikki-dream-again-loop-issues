@tool
extends Event

func _ready() -> void:
	if Engine.is_editor_hint():
		if (self as Node) is SubViewport:
			self.canvas_item_default_texture_filter = Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
			self.canvas_item_default_texture_repeat = Viewport.DefaultCanvasItemTextureRepeat.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
			self.size 				= Vector2(480, 270)
			self.size_2d_override	= Vector2(480, 270)
	
		if (self as Node) is Control:
			self.global_position = Vector2.ZERO
			self.custom_minimum_size = Vector2(480, 270)
			self.z_index = -25
func _execute() -> void:
	PanoramaSystem.instance.apply_panorama(self)
