@tool 
class_name TouchObject extends CharacterBody3D

@export_flags_2d_physics var spawn_flags: int = 0
@export_flags_2d_physics var mask_flags: int = 15

func _func_godot_apply_properties(properties: Dictionary) -> void:
	spawn_flags = int(properties.get("spawnflags", 0))
	mask_flags = int(properties.get("maskflags", 15))

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
