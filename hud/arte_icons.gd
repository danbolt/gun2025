class_name ArteIcons extends Control

func mystic_arte(arte_index: int) -> void:
	var associated_key: Key = Key.KEY_Q
	var associated_button: JoyButton = JoyButton.JOY_BUTTON_A
	
	if arte_index == 0:
		associated_key = InputSpriteMappings.ARTE_0_KEY
		associated_button = JoyButton.JOY_BUTTON_A
	if arte_index == 1:
		associated_key = InputSpriteMappings.ARTE_1_KEY
		associated_button = JoyButton.JOY_BUTTON_B
	if arte_index == 2:
		associated_key = InputSpriteMappings.ARTE_2_KEY
		associated_button = JoyButton.JOY_BUTTON_X
	if arte_index == 3:
		associated_key = InputSpriteMappings.ARTE_3_KEY
		associated_button = JoyButton.JOY_BUTTON_Y
		
	
	var candidate_texture: Texture2D = InputSpriteMappings.UNKNOWN_TEXTURE
	
	if Settings.last_input_mode == Settings.LastUsedMode.KBD:
		if InputSpriteMappings.KEY_TEXTURES.has(associated_key):
			candidate_texture = InputSpriteMappings.KEY_TEXTURES[associated_key]
	else:
		if Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.XBOX:
			if InputSpriteMappings.BUTTON_TEXTURES_XBOX.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[associated_button]

		elif Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.SWITCH:
			if InputSpriteMappings.BUTTON_TEXTURES_SWITCH.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[associated_button]

		elif Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.PLAYSTATION:
			if InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[associated_button]
	
	const candidate_count: int = 20
	var tweened_count := 0
	for child: TextureRect in get_children():
		if tweened_count == candidate_count:
			break
		if child.visible:
			continue
			
		var next: TextureRect = child
		next.texture = candidate_texture
		next.visible = true
		next.position = Vector2(size.x * 0.5, size.y * 0.5) + Vector2(randf_range(size.x * 0.4, size.x * 0.6), 0.0).rotated(randf_range(0.0, TAU))
		next.scale = Vector2(0.5, 0.5)
		next.self_modulate = Color.TRANSPARENT
		
		var delay := randf_range(0.0, 0.3)
		var t_time: float = randf_range(0.22, 0.25)
		
		var t_scale = get_tree().create_tween()
		t_scale.tween_interval(delay)
		t_scale.tween_property(next, "scale", Vector2(1.1, 1.1), t_time)
		t_scale.set_ease(Tween.EASE_IN)
		t_scale.set_trans(Tween.TRANS_CUBIC)
		t_scale.finished.connect(func() -> void: next.visible = false )
		
		var t_position = get_tree().create_tween()
		t_position.tween_interval(delay)
		t_position.tween_property(next, "position", next.position + Vector2(0.0, randf() * -100.0), t_time)
		t_position.set_ease(Tween.EASE_OUT)
		t_position.set_trans(Tween.TRANS_CUBIC)
		
		var t_alpha = get_tree().create_tween()
		t_alpha.tween_interval(delay)
		t_alpha.tween_property(next, "self_modulate", Color.WHITE, 0.125)
		t_alpha.set_ease(Tween.EASE_IN)
		t_alpha.set_trans(Tween.TRANS_CUBIC)
		t_alpha.tween_property(next, "self_modulate",  Color.TRANSPARENT, t_time- 0.125)
		t_alpha.set_ease(Tween.EASE_OUT)
		t_alpha.set_trans(Tween.TRANS_CUBIC)
			
			
		tweened_count += 1


func _ready() -> void:
	for child: Control in get_children():
		child.visible = false
