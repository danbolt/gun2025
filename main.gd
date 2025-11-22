extends Node

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tree := get_tree()
	if tree == null:
		return
		
	if Input.is_action_just_pressed("pause"):
		tree.paused = !tree.paused
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !tree.paused else Input.MOUSE_MODE_VISIBLE
