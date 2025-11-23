class_name Gameplay extends Node3D

func _process(_delta: float) -> void:
	$Camera3D.physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
