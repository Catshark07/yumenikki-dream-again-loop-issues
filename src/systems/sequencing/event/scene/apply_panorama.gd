@tool
extends Event

@export var subviewport: SubViewport
@export var pivot: Marker2D

func _ready() -> void:
	if 	Utils.get_child_node_or_null(self, "pivot") == null:
		pivot = Utils.add_child_node(self, Marker2D.new(), "pivot")
		
	if 	Utils.get_child_node_or_null(self, "subviewport") == null:
		subviewport = Utils.add_child_node(self, SubViewport.new(), "subviewport")
	
	subviewport.canvas_item_default_texture_filter = Viewport.DefaultCanvasItemTextureFilter.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	subviewport.canvas_item_default_texture_repeat = Viewport.DefaultCanvasItemTextureRepeat.DEFAULT_CANVAS_ITEM_TEXTURE_REPEAT_MIRROR
	subviewport.size 				= Vector2(480, 270)
	subviewport.size_2d_override	= Vector2(480, 270)
	subviewport.transparent_bg		= true
	subviewport.own_world_3d		= true
				
func _execute() -> void:
	PanoramaSystem.instance.apply_panorama(subviewport, pivot.global_position)
