@tool 
class_name TouchObject extends CharacterBody3D

@export var a: bool = false
@export var b: bool = false
@export var c: bool = false
@export var d: bool = false

func _func_godot_apply_properties(properties: Dictionary) -> void:
	a = int(properties.get("1", 0))
	b = int(properties.get("2", 0))
	c = int(properties.get("3", 0))
	d = int(properties.get("4", 0))

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
