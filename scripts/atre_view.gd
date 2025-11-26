@tool
class_name ArteView extends Node3D

@onready var input_icon_0: InputIcon = %InputIcon_0
@onready var input_icon_1: InputIcon = %InputIcon_1
@onready var input_icon_2: InputIcon = %InputIcon_2
@onready var input_icon_3: InputIcon = %InputIcon_3

@export var extent_distance: float = 1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_icon_0.associated_button = JoyButton.JOY_BUTTON_A
	input_icon_1.associated_button = JoyButton.JOY_BUTTON_B
	input_icon_2.associated_button = JoyButton.JOY_BUTTON_X
	input_icon_3.associated_button = JoyButton.JOY_BUTTON_Y
	
	input_icon_0.associated_key = Key.KEY_E
	input_icon_1.associated_key = Key.KEY_3
	input_icon_2.associated_key = Key.KEY_Q
	input_icon_3.associated_key = Key.KEY_1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var current_viewport := get_viewport()
	if current_viewport != null:
		var current_camera := current_viewport.get_camera_3d()
		if current_camera != null:
			look_at(current_camera.global_position, Vector3.UP, true)
	
	if Settings.last_input_mode == Settings.LastUsedMode.KBD:
		input_icon_0.position = lerp(input_icon_0.position, Vector3.RIGHT * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_1.position = lerp(input_icon_1.position, Vector3.UP * extent_distance + Vector3.RIGHT * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_2.position = lerp(input_icon_2.position, Vector3.LEFT * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_3.position = lerp(input_icon_3.position, Vector3.LEFT * extent_distance + Vector3.UP * extent_distance, 1.0 - pow(0.131, delta * 2.131))
	else:
		input_icon_0.position = lerp(input_icon_0.position, Vector3.DOWN * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_1.position = lerp(input_icon_1.position, Vector3.RIGHT * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_2.position = lerp(input_icon_2.position, Vector3.LEFT * extent_distance, 1.0 - pow(0.131, delta * 2.131))
		input_icon_3.position = lerp(input_icon_3.position, Vector3.UP * extent_distance, 1.0 - pow(0.131, delta * 2.131))
	
	
