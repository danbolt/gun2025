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
	
func _ready() -> void:
	load_and_add_level("res://levels/wood_obsidian.tscn")
