class_name TouchObject extends CharacterBody3D

@export_flags("One", "Two", "Three", "Four") var numbers: int = 0

func _physics_process(delta: float) -> void:
	print(delta)
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
