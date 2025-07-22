class_name SBComponent
extends Node

var sentient: SentientBase
@export var active: bool = true

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	
	var sb_component_receiver = get_parent()
	if !sb_component_receiver is SBComponentReceiver: return
	
	GlobalUtils.connect_to_signal(_on_bypass_enabled, sb_component_receiver.bypass_enabled)
	GlobalUtils.connect_to_signal(_on_bypass_lifted, sb_component_receiver.bypass_lifted)

func _setup(_sentient: SentientBase) -> void: sentient = _sentient
func _update(_delta: float) -> void: pass
func _physics_update(_delta: float) -> void: pass
func _input_pass(_event: InputEvent) -> void: pass

func update(_delta: float) -> void:
	if active: _update(_delta)
func physics_update(_delta: float) -> void:
	if active: _physics_update(_delta)
func input_pass(_event: InputEvent) -> void:
	if active: _input_pass(_event)

func _on_bypass_enabled() -> void: pass
func _on_bypass_lifted() -> void: pass
