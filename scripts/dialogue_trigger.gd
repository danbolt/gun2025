class_name DialogueTrigger extends Area3D

@export var timeline: DialogicTimeline

@export var queue_free_on_entry: bool = true

func on_body_entered(intruder: Node3D) -> void:
	assert(intruder is PlayerController, "non-player entered Dialogue")
	Dialogic.start(timeline).process_mode = Node.PROCESS_MODE_ALWAYS
	
	body_entered.disconnect(on_body_entered)
	
	if queue_free_on_entry:
		queue_free()

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2 # Player layer
	
	body_entered.connect(on_body_entered)
	
