@tool
class_name ExitZone extends Area3D

@export var next_level: String = "wood_obsidian"

@onready var label: Label3D = $Label3D
func _func_godot_apply_properties(properties: Dictionary) -> void:
	next_level = str(properties.get("next_level", "palace"))
	
func fire_exit() -> void:
	get_tree().call_group("listen_for_level_change", "level_cleared", next_level)
	queue_free()

func on_body_entered(intruder: Node3D) -> void:
	assert(intruder is PlayerController, "non-player entered Dialogue")
	
	body_entered.disconnect(on_body_entered)
	fire_exit.call_deferred()

func _ready() -> void:
	if Engine.is_editor_hint():
		return
		
	collision_layer = 0
	collision_mask = 2 # Player layer
	
	body_entered.connect(on_body_entered)
	
func _process(delta: float) -> void:
	label.rotate_y(delta * 3.161)
