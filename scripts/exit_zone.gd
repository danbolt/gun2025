class_name ExitZone extends Area3D

@export var next_level: String = "wood_obsidian"

func wait_then_emit() -> void:
	await get_tree().create_timer(4.0, false, true).timeout
	
	get_tree().call_group("listen_for_level_change", "new_level", next_level)
	queue_free()

func on_body_entered(intruder: Node3D) -> void:
	assert(intruder is PlayerController, "non-player entered Dialogue")
	
	body_entered.disconnect(on_body_entered)
	wait_then_emit.call_deferred()

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # Player layer
	
	body_entered.connect(on_body_entered)
