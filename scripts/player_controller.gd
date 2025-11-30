class_name PlayerController extends CharacterBody3D

signal struck_victim(victim: ArteView)

@onready var knife_hand_animation_player := $CharacterCamera/HandsRoot/knife_hand2/AnimationPlayer
@onready var mystic_hand_animation_player := $CharacterCamera/HandsRoot/mystic_hand/AnimationPlayer

@onready var character_camera: PhantomCamera3D = $CharacterCamera
@export var camera_rotation_y: float:
	get:
		return character_camera.rotation.y
	set(value):
		character_camera.rotation.y = value


@export var move_speed: float = 8.0
@export var jump_velocity: float = 64.0
@export var sprint_modifier: float = 0.125

var is_knocked_back: bool = false
var knockback_direction: Vector3 = Vector3.FORWARD
var knockback_speed: float = 64
var knockback_time: float = 0.0
var knockback_duration: float = 1.0
var in_air_from_knocked_back: bool = false

var camera_rot_z: float = 0.0

@export var max_velocity: Vector2 = Vector2(10.0, 10.0)

const MOUSE_SENSITIVITY_X: float = 0.125
const MOUSE_SENSITIVITY_Y: float = 0.125
const GAMEPAD_SENSITIVITY_X: float = 3.0
const GAMEPAD_SENSITIVITY_Y: float = 3.0

var _accumulated_input: Vector2 = Vector2.ZERO

func z_rot(dest_z: float, duration: float) -> void:
	var tree := get_tree()
	if tree == null:
		return
	
	var z_tween = tree.create_tween()
	z_tween.tween_property(self, "camera_rot_z", dest_z, duration * 0.5)
	z_tween.set_ease(Tween.EASE_IN)
	z_tween.set_trans(Tween.TRANS_CUBIC)
	z_tween.tween_property(self, "camera_rot_z", 0.0, duration * 0.5)
	z_tween.set_ease(Tween.EASE_OUT)
	z_tween.set_trans(Tween.TRANS_CUBIC)

func update_fov(_new_fov: float) -> void:
	character_camera.fov = Settings.fov

func struck(victim: ArteView) -> void:
	struck_victim.emit(victim)
	
	knife_hand_animation_player.play("strike")
	if not is_on_floor():
		get_tree().call_group("listen_for_score_events", "score_event", ScoreTable.SCORE_EVENT_MIDAIR_STRIKE)

func damaged(damager: ArteView) -> void:
	if is_knocked_back:
		return
	
	get_tree().call_group("listen_for_score_events", "score_event", ScoreTable.SCORE_EVENT_PLAYER_STRUCK)
	
	is_knocked_back = true
	knockback_time = knockback_duration
	knockback_direction = (global_position - damager.global_position + Vector3.UP * 3.5).normalized()
	
	var dot_with_right := character_camera.basis.x.dot(knockback_direction)
	
	z_rot(PI * 0.125 * (-1.0 if dot_with_right < 0.0 else 1.0), knockback_duration)
	
	velocity = knockback_direction * knockback_speed
	in_air_from_knocked_back = true

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		_accumulated_input += (event as InputEventMouseMotion).relative

func _ready() -> void:
	_accumulated_input = Vector2.ZERO
	
	mystic_hand_animation_player.play("idle")
	mystic_hand_animation_player.animation_finished.connect(_revert_mystic_hand_on_end)
	
	knife_hand_animation_player.play("idle")
	knife_hand_animation_player.animation_finished.connect(_play_idle_on_strike_end)
	
	character_camera.fov = Settings.fov
	camera_rot_z = 0.0
	
	character_camera.set_follow_target(self)

func _process_mouse_turning(delta: float) -> void:
	character_camera.rotate_y(_accumulated_input.x * MOUSE_SENSITIVITY_X * Settings.x_sensitivity * delta * -1.0  * (1.0 if not Settings.x_invert else -1.0))
	character_camera.rotate(character_camera.basis.x.normalized(), _accumulated_input.y * MOUSE_SENSITIVITY_Y * Settings.y_sensitivity * delta * -1.0 * (1.0 if not Settings.y_invert else -1.0))
	
	var camera_up := character_camera.basis * Vector3.UP
	var camera_up_dot_from_up := camera_up.dot(Vector3.UP)
	if camera_up_dot_from_up < 0.0:
		var camera_forward := character_camera.basis * Vector3.FORWARD
		var camera_right := character_camera.basis * Vector3.RIGHT
		if camera_forward.y > 0.0:
			character_camera.basis = Basis(camera_right, Vector3.DOWN.cross(camera_right), Vector3.DOWN)
		else:
			character_camera.basis = Basis(camera_right, Vector3.UP.cross(camera_right), Vector3.UP)
			
	character_camera.rotation.z = camera_rot_z
			
	_accumulated_input = Vector2.ZERO

func _process_gamepad_turning(delta: float) -> void:
	var input_horizontal := Input.get_axis("turn_left", "turn_right") * (1.0 if not Settings.x_invert else -1.0)
	var input_vertical := Input.get_axis("turn_down", "turn_up") * (1.0 if not Settings.y_invert else -1.0)
	character_camera.rotate_y(input_horizontal * delta * -1.0 * GAMEPAD_SENSITIVITY_X * Settings.x_sensitivity)
	character_camera.rotate(character_camera.basis.x.normalized(), input_vertical * delta * GAMEPAD_SENSITIVITY_Y * Settings.y_sensitivity)
	
	var camera_up := character_camera.basis * Vector3.UP
	var camera_up_dot_from_up := camera_up.dot(Vector3.UP)
	if camera_up_dot_from_up < 0.0:
		var camera_forward := character_camera.basis * Vector3.FORWARD
		var camera_right := character_camera.basis * Vector3.RIGHT
		if camera_forward.y > 0.0:
			character_camera.basis = Basis(camera_right, Vector3.DOWN.cross(camera_right), Vector3.DOWN)
		else:
			character_camera.basis = Basis(camera_right, Vector3.UP.cross(camera_right), Vector3.UP)
			
	character_camera.rotation.z = camera_rot_z

func _process(delta: float) -> void:
	character_camera.fov = Settings.fov
	
	_process_mouse_turning(delta)
	_process_gamepad_turning(delta)

func process_motion(_delta: float) -> void:
	var current_viewport := get_viewport()
	if current_viewport == null:
		return
	var current_camera := current_viewport.get_camera_3d()
	if current_camera == null:
		return
	
	var input_direction := Vector3(Input.get_axis("move_left", "move_right"), 0.0, Input.get_axis("move_backward", "move_forward"))
	var oriented_input := input_direction * current_camera.global_basis
	oriented_input.y = 0
	oriented_input = oriented_input.normalized() * input_direction.length()
	
	var speed := move_speed * (sprint_modifier if Input.is_action_pressed("sprint") else 1.0)
	velocity.x = oriented_input.x * speed
	velocity.z = oriented_input.z * speed * -1.0
	
	if is_on_floor():
		in_air_from_knocked_back = false
	
	if in_air_from_knocked_back:
		velocity.x += knockback_direction.x * knockback_speed
		velocity.z += knockback_direction.z * knockback_speed

func _process_mystic_artes() -> void:
	if not Input.is_action_pressed("sprint"):
		return
		
	if Input.is_action_just_pressed("arte_0"):
		get_tree().call_group("mystic", "mystic_arte", 0)
		mystic_hand_animation_player.play("arte_0")
	
	if Input.is_action_just_pressed("arte_1"):
		get_tree().call_group("mystic", "mystic_arte", 1)
		mystic_hand_animation_player.play("arte_1")
	
	if Input.is_action_just_pressed("arte_2"):
		get_tree().call_group("mystic", "mystic_arte", 2)
		mystic_hand_animation_player.play("arte_2")
	
	if Input.is_action_just_pressed("arte_3"):
		get_tree().call_group("mystic", "mystic_arte", 3)
		mystic_hand_animation_player.play("arte_3")

func _play_idle_on_strike_end(anim_name: String) -> void:
	if anim_name == "strike":
		knife_hand_animation_player.play("idle")

func _revert_mystic_hand_on_end(_name: String) -> void:
	await get_tree().create_timer(1.0, false).timeout
	mystic_hand_animation_player.play("idle")

func _physics_process(delta: float) -> void:
	_process_mystic_artes()
	
	if is_knocked_back:
		knockback_time -= delta
		if knockback_time < 0.0:
			is_knocked_back = false
	
	if not is_knocked_back:
		process_motion(delta)
		
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
		elif Input.is_action_just_pressed("jump") and not Input.is_action_pressed("sprint"):
			velocity.y = jump_velocity
	else:

		if not is_on_floor():
			velocity.y += get_gravity().y * delta
		
	velocity.x = clampf(velocity.x, -max_velocity.x, max_velocity.x)
	velocity.y = clampf(velocity.y, -max_velocity.y, max_velocity.y)
	
	move_and_slide()
