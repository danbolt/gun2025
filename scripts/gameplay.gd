class_name Gameplay extends Node3D

@onready var level := %Level

@onready var player_controller: PlayerController = %PlayerController

@onready var hp_bar: ProgressBar = %HPBar

@export var max_hp: float = 100
@export var hp: float = max_hp

var target_score: int = 0
var currently_displayed_score: int = 0
@onready var score_display: Label = %ScoreDisplay

var arrived_at_exit: bool = false
@onready var level_clear_root: Control = %LevelClear
@onready var clear_label: Label = %ClearLabel

func level_clear() -> void:
	if arrived_at_exit:
		return
	
	arrived_at_exit = true
	
	level_clear_root.visible = true
	clear_label.visible_ratio = 0.0
	
	var t :=  get_tree().create_tween()
	t.tween_property(clear_label, "visible_ratio", 1.0, 0.516)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

func set_score_to_display(new_target: int) -> void:
	target_score = new_target

func on_player_struck_victim(victim: ArteView) -> void:
	hp = clamp(hp + (victim.get_parent_node_3d() as TouchObject).bonus, 0.0, max_hp)

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
	
func dialogue_finished() -> void:
	var cameras := level.find_children("", "PhantomCamera3D", true, false)
	for camera: PhantomCamera3D in cameras:
		camera.priority = 0
	
func _ready() -> void:
	$Camera3D.process_mode = Node.PROCESS_MODE_ALWAYS
	
	arrived_at_exit = false
	
	target_score = 0
	currently_displayed_score = 0
	
	player_controller.struck_victim.connect(on_player_struck_victim)
	
	Dialogic.signal_event.connect(on_dialogic_signal)
	Dialogic.timeline_ended.connect(dialogue_finished)
	
func _process_hp(delta: float) -> void:
	if arrived_at_exit:
		return
	
	const DEPLETE_SPEED: float = 2.0
	hp -= delta * DEPLETE_SPEED
	if hp < 0:
		hp = 0

func _physics_process(delta: float) -> void:
	_process_hp(delta)
	
	var next_score: float = move_toward(float(currently_displayed_score), float(target_score), delta * 500.0)
	currently_displayed_score = int(next_score)
	score_display.text = "%06d" % (currently_displayed_score)
	
func _process(_delta: float) -> void:
	hp_bar.value = hp
	hp_bar.max_value = max_hp
	
	
