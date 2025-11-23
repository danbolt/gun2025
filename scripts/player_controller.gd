class_name PlayerController extends CharacterBody3D

@onready var character_camera: PhantomCamera3D = $CharacterCamera

@export var move_speed: float = 2.0
@export var jump_velocity: float = 8.0

@export var max_velocity: Vector2 = Vector2(10.0, 10.0)

const MOUSE_SENSITIVITY_X: float = 0.125
const MOUSE_SENSITIVITY_Y: float = 0.125
const GAMEPAD_SENSITIVITY_X: float = 3.0
const GAMEPAD_SENSITIVITY_Y: float = 3.0

var _accumulated_input: Vector2 = Vector2.ZERO

func update_fov(_new_fov: float) -> void:
	character_camera.fov = Settings.fov

func _input(event: InputEvent) -> void:
	if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
		return
	if event is InputEventMouseMotion:
		_accumulated_input += (event as InputEventMouseMotion).relative

func _ready() -> void:
	_accumulated_input = Vector2.ZERO
	
	character_camera.fov = Settings.fov
	
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
	velocity.x = oriented_input.x * move_speed
	velocity.z = oriented_input.z * move_speed * -1.0
	

func _physics_process(delta: float) -> void:
	process_motion(delta)
	
	if not is_on_floor():
		velocity.y += -8.0 * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity
		
	velocity.x = clampf(velocity.x, -max_velocity.x, max_velocity.x)
	velocity.y = clampf(velocity.y, -max_velocity.y, max_velocity.y)
	
	move_and_slide()
