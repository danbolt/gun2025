class_name Gameplay extends Node3D

@onready var level := %Level

@onready var player_controller: PlayerController = %PlayerController

func remove_level() -> void:
	for child: Node in level.get_children():
		child.queue_free()
		level.remove_child(child)

func load_and_add_level(path: String) -> void:
	assert(level.get_child_count() == 0, "Tried to load/add a level with one there: %s" % path)
	var new_level = load(path)
	level.add_child(new_level.instantiate())
	
	setup_player_location()
	
func setup_player_location() -> void:
	var spawn_points := level.find_children("", "SpawnPoint", true, false)
	for spawn_point: SpawnPoint in spawn_points:
		player_controller.position = spawn_point.position
		player_controller.camera_rotation_y = spawn_point.rotation.y
		break
	
func on_dialogic_signal(data: Variant) -> void:
	if data is Dictionary:
		if data.has("Camera") and data.has("Priority"):
			var camera_name: String = data["Camera"]
			var priority: int = data["Priority"]
			
			var cameras := level.find_children("", "PhantomCamera3D", true, false)
			for camera: PhantomCamera3D in cameras:
				if camera.name == camera_name:
					camera.priority = priority
	
func _ready() -> void:
	$Camera3D.process_mode = Node.PROCESS_MODE_ALWAYS
	
	Dialogic.signal_event.connect(on_dialogic_signal)
	
