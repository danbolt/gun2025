@tool
class_name ArteView extends Node3D

signal attacked_player(player: PlayerController)
signal damaged()

@onready var icons: Node3D = $Icons

@onready var input_icon_0: InputIcon = %InputIcon_0
@onready var input_icon_1: InputIcon = %InputIcon_1
@onready var input_icon_2: InputIcon = %InputIcon_2
@onready var input_icon_3: InputIcon = %InputIcon_3

@onready var strike_marker: Node3D = %StrikeMarker

@onready var hitbox: Area3D = %Hitbox

@export var extent_distance: float = 1.0
@export var out_distance: float = 2.0

@export var all_pressed: bool:
	get:
		return (input_icon_0.pressed or (input_icon_0.visible == false)) and (input_icon_1.pressed or (input_icon_1.visible == false)) and (input_icon_2.pressed or (input_icon_2.visible == false)) and (input_icon_3.pressed or (input_icon_3.visible == false))
		
func on_intruder_entered_hitbox(intruder: Node3D) -> void:
	var player: PlayerController = intruder as PlayerController
	if all_pressed:
		player.struck(self)
		damaged.emit()
	else:
		attacked_player.emit(player)
		player.damaged(self)
		
func set_flags(flags: int) -> void:
	input_icon_0.pressed = (flags & 1) == 1
	input_icon_1.pressed = (flags & 2) == 2
	input_icon_2.pressed = (flags & 4) == 4
	input_icon_3.pressed = (flags & 8) == 8
	
func set_mask(mask: int) -> void:
	input_icon_0.visible = (mask & 1) == 1
	input_icon_1.visible = (mask & 2) == 2
	input_icon_2.visible = (mask & 4) == 4
	input_icon_3.visible = (mask & 8) == 8

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	input_icon_0.associated_button = JoyButton.JOY_BUTTON_A
	input_icon_1.associated_button = JoyButton.JOY_BUTTON_B
	input_icon_2.associated_button = JoyButton.JOY_BUTTON_X
	input_icon_3.associated_button = JoyButton.JOY_BUTTON_Y
	
	if not Engine.is_editor_hint():
		hitbox.body_entered.connect(on_intruder_entered_hitbox)
	
	input_icon_0.associated_key = InputSpriteMappings.ARTE_0_KEY
	input_icon_1.associated_key = InputSpriteMappings.ARTE_1_KEY
	input_icon_2.associated_key = InputSpriteMappings.ARTE_2_KEY
	input_icon_3.associated_key = InputSpriteMappings.ARTE_3_KEY

func mystic_arte(arte_index: int) -> void:
	if Engine.is_editor_hint():
		return
		
	if arte_index == 0:
		input_icon_0.pressed = !input_icon_0.pressed
	
	if arte_index == 1:
		input_icon_1.pressed = !input_icon_1.pressed
	
	if arte_index == 2:
		input_icon_2.pressed = !input_icon_2.pressed
	
	if arte_index == 3:
		input_icon_3.pressed = !input_icon_3.pressed

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if strike_marker:
		strike_marker.visible = all_pressed
	
	if icons:
		icons.position = Vector3.BACK * out_distance
	
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
	
	
