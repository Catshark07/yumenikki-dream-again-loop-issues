@tool

class_name EVN_TeleporteSentient
extends Event

@export var displace: bool = false

@export_group("Properties.")
@export var sentient: SentientBase
@export var dis_vector: Vector2i = Vector2i.ZERO
@export var heading: SentientBase.compass_headings
@export var change_heading: bool = false

@export_group("Components.")
@export var marker: Marker2D

func _ready() -> void:
	marker = Utils.get_child_node_or_null(self, "marker")
	if 	marker == null:
		marker = Utils.add_child_node(self, Marker2D.new(), "marker")

	if !Engine.is_editor_hint(): 
		Utils.disconnect_from_signal(_draw, marker.draw)
		super()
	else:
		Utils.connect_to_signal(_draw, marker.draw)
		process_mode = Node.PROCESS_MODE_ALWAYS
	
func _execute	() -> void:
	match displace:
		true: 	sentient.global_position += Vector2(dis_vector)
		false: 	sentient.global_position = marker.global_position
	
	if change_heading: sentient.heading = heading
func _validate() -> bool: 
	return sentient != null and marker != null

func _draw() -> void:
	if Engine.is_editor_hint():
		marker.draw_texture(
			preload("res://src/systems/components/independent/pl_spawn.png"), 
			Vector2i(-24, -32) + dis_vector,
			Color(0.521, 0.55, 0.198, 0.322))
func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		marker.queue_redraw()
