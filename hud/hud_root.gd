class_name HUDRoot extends AspectRatioContainer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Settings.hud_aspect_ratio > 0.0:
		ratio = Settings.hud_aspect_ratio
	else:
		var current_window := get_window()
		if current_window != null:
			var aspect_ratio := current_window.size.x / float(current_window.size.y)
			ratio = aspect_ratio
