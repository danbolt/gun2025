class_name Gameplay extends Node3D

signal player_death()

@onready var level := %Level

@onready var player_controller: PlayerController = %PlayerController

@onready var hp_number_label: Label = %HPNumberLabel
@onready var time_bonus_label: Label = %TimeBonusLabel
@onready var time_bonus_label_original_position: Vector2 = time_bonus_label.position

@export var hp: float = 25

const DEPLETE_SPEED: float = 1.0

@onready var hud_bottom_right: Node = %"HUD Bottom Right"

var target_score: int = 0
var currently_displayed_score: int = 0
@onready var score_display: Label = %ScoreDisplay

var arrived_at_exit: bool = false
@onready var level_clear_root: Control = %LevelClear
@onready var clear_label: Label = %ClearLabel

var player_has_died: bool = false
@onready var death_clear_root: Control = %DeathScreen
@onready var death_label: Label = %DeathLabel

var onep_material: ShaderMaterial = null
var one_display_t_value: float = 0.0
var one_display_t_goal_value: float = 0.0

var seconds_passed_in_game_time: float = 0.0

const COMBO_MULTIPLIERS: Array[float] = [ 1.0, 2.0, 3.0, 5.0, 6.0, 8.0 ]
const COMBO_TIER_DURATIONS: Array[float] = [ 1.0, 1.0, 1.0, 1.0, 1.0, 1.0 ]
const COMBO_DEPLETE_SPEED: Array[float] = [ 0.30, 0.20, 0.17, 0.13, 0.10, 0.9 ]
var current_combo_index: int = 0
var combo_time: float = 0.0

@onready var combo_bar: TextureProgressBar = %ComboBar
@onready var combo_mutliplier_label: Label = %ComboMultiplier

@onready var idle_portrait: Texture2D = preload("res://textures/portrait_idle.png")
@onready var damaged_portrait: Texture2D = preload("res://textures/portrait_damaged.png")
@onready var dead_portrait: Texture2D = preload("res://textures/portrait_dead.png")
@onready var strike_portrait: Texture2D = preload("res://textures/portrait_strike.png")
@onready var portrait_rect: TextureRect = %PortraitRect
const DEFAULT_PORTRAIT_RECT_POSITION: Vector2 = Vector2(-66, -66)
const WALK_AMPLITUDE: float = 16

func level_clear() -> void:
	if arrived_at_exit:
		return
	
	arrived_at_exit = true
	
	level_clear_root.visible = true
	clear_label.visible_ratio = 0.0
	
	var t :=  get_tree().create_tween()
	t.tween_property(clear_label, "visible_ratio", 1.0, 0.516)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)

func kill_player() -> void:
	player_has_died = true
	death_clear_root.visible = true
	death_label.visible_ratio = 0.0
	
	hud_bottom_right.queue_free()
	
	player_controller.stop_movement = true
	
	var t :=  get_tree().create_tween()
	t.tween_property(death_label, "visible_ratio", 1.0, 0.965116)
	t.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	player_death.emit()

func set_score_to_display(new_target: int) -> void:
	target_score = new_target

func on_player_struck_victim(victim: ArteView) -> void:
	hp = hp + (victim.get_parent_node_3d() as TouchObject).bonus
	
	time_bonus_label.visible = true
	time_bonus_label.position = time_bonus_label_original_position
	time_bonus_label.modulate = Color.WHITE
	
	var pos_tween := get_tree().create_tween()
	pos_tween.tween_property(time_bonus_label, "position", time_bonus_label_original_position + Vector2(0.0, 32.0), 0.6)
	pos_tween.set_trans(Tween.TRANS_CUBIC)
	pos_tween.set_ease(Tween.EASE_IN)
	
	var scale_tween := get_tree().create_tween()
	scale_tween.tween_property(time_bonus_label, "scale", Vector2(1.2, 1.2), 0.6 * 0.5)
	scale_tween.set_trans(Tween.TRANS_CUBIC)
	scale_tween.set_ease(Tween.EASE_IN)
	scale_tween.tween_property(time_bonus_label, "scale", Vector2(1.0, 1.0), 0.6 * 0.5)
	
	var alpha_tween := get_tree().create_tween()
	alpha_tween.tween_property(time_bonus_label, "modulate", Color.TRANSPARENT, 0.6)
	alpha_tween.set_trans(Tween.TRANS_CUBIC)
	alpha_tween.set_ease(Tween.EASE_IN)
	alpha_tween.finished.connect(func() -> void: time_bonus_label.visible = false)

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
	onep_material = ((%onep_display as CanvasItem).material as ShaderMaterial)
	one_display_t_value = 0.0
	one_display_t_goal_value = 0.0
	
	current_combo_index = 0
	combo_time = 0
	
	seconds_passed_in_game_time = 0.0
	
	arrived_at_exit = false
	player_has_died = false
	
	target_score = 0
	currently_displayed_score = 0
	
	player_controller.struck_victim.connect(on_player_struck_victim)
	
	Dialogic.signal_event.connect(on_dialogic_signal)
	Dialogic.timeline_ended.connect(dialogue_finished)
	
func _process_portrait(delta: float) -> void:
	var target_offset := Vector2.ZERO
	var lerp_speed := 10.0
	if player_has_died:
		portrait_rect.texture = dead_portrait
	elif player_controller.is_knocked_back:
		portrait_rect.texture = damaged_portrait
		
		target_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 30.0
		lerp_speed = 20.0
	elif player_controller.is_striking:
		portrait_rect.texture = strike_portrait
		
		target_offset = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)) * 15.0
		lerp_speed = 10.0
	else:
		portrait_rect.texture = idle_portrait
		
		var player_velocity := player_controller.velocity
		player_velocity.y = 0
		if player_controller.is_on_floor() and not player_velocity.is_zero_approx():
			target_offset = Vector2(0.0, sin(seconds_passed_in_game_time * 18.5610) * 10.0)
			lerp_speed = 20.0
		else:
			target_offset = Vector2.ZERO if player_controller.is_on_floor() else Vector2.DOWN * 32.0
			
	portrait_rect.position = lerp(portrait_rect.position, DEFAULT_PORTRAIT_RECT_POSITION + target_offset,  1.0 - pow(0.5, delta * lerp_speed))
	
func _process_hp(delta: float) -> void:
	if arrived_at_exit:
		return
		
	if player_has_died:
		return
	
	hp -= delta * DEPLETE_SPEED
	if hp < 0:
		hp = 0
		
	if is_zero_approx(hp) and (not player_has_died):
		kill_player()

func _process_combo(delta: float) -> void:
	combo_time -= delta * COMBO_DEPLETE_SPEED[current_combo_index]
	if current_combo_index > 0 and combo_time <= 0.0:
		current_combo_index = maxi(current_combo_index - 1, 0)
		combo_time = COMBO_TIER_DURATIONS[current_combo_index]
		
	ScoreTable.current_multiplier = COMBO_MULTIPLIERS[current_combo_index]
		
	combo_bar.value = combo_time / COMBO_TIER_DURATIONS[current_combo_index]
	combo_mutliplier_label.text = "%.1fx" % COMBO_MULTIPLIERS[current_combo_index]

func _physics_process(delta: float) -> void:
	_process_hp(delta)
	_process_portrait(delta)
	_process_combo(delta)
	
	var next_score: float = move_toward(float(currently_displayed_score), float(target_score), delta * 500.0)
	currently_displayed_score = int(next_score)
	score_display.text = "%06d" % (currently_displayed_score)
	
func _process(delta: float) -> void:
	if not player_has_died and not arrived_at_exit:
		seconds_passed_in_game_time += delta
	
	hp_number_label.text = "%3d" % hp
	
	var lerp_speed: float = 10.0
	if player_controller.is_knocked_back:
		one_display_t_goal_value = 2.0
		lerp_speed = 20.0
	elif Input.is_action_pressed("sprint"):
		one_display_t_goal_value = 0.85
		lerp_speed = 10.4161
	else:
		one_display_t_goal_value = 0.0
	
	if player_has_died:
		one_display_t_goal_value = 6.0
		lerp_speed = 12.81717
	
	one_display_t_value = lerp(one_display_t_value, one_display_t_goal_value, 1.0 - pow(0.5, delta * lerp_speed))
	
	var black_value: bool = true
	if Input.is_action_pressed("sprint"):
		black_value = false
	if player_controller.is_knocked_back:
		black_value = true
	if player_has_died:
		black_value = true
	
	onep_material.set_shader_parameter("black", black_value)
	onep_material.set_shader_parameter("t", one_display_t_value)
	
	
