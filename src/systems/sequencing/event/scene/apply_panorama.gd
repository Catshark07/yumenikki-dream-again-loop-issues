@tool
extends Event
@export_tool_button("Preview Panorama In Scene") var preview: Callable = __preview

func _ready() -> void:
	self.canvas_item_default_texture_filter = Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	self.canvas_item_default_texture_repeat = Viewport.DefaultCanvasItemTextureRepeat.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
	self.size 				= Vector2(480, 270)
	self.size_2d_override	= Vector2(480, 270)
	self.transparent_bg		= true
	self.own_world_3d		= true
				
func _execute() -> void:
	PanoramaSystem.instance.apply_panorama(self)

func __preview() -> void:
	if (self as Node) is SubViewport:
		PanoramaPreviewer.preview((self as Node) as SubViewport)
