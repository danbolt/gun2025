class_name GameSettingsPanel extends Control

@onready var fullscreen_toggle := $PanelContainer/MarginContainer/VBoxContainer/FullscreenToggle
@onready var resolution_scale := $PanelContainer/MarginContainer/VBoxContainer/ResolutionScale
@onready var resolution_scale_mode := $PanelContainer/MarginContainer/VBoxContainer/ResolutionScaleMode
@onready var hud_aspect_ratio := $PanelContainer/MarginContainer/VBoxContainer/HUDAspectRatio
@onready var fov_text: Label = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FOVText
@onready var fov_slider: HSlider = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/FOVSlider

@onready var x_invert_button := $PanelContainer/MarginContainer/VBoxContainer/Inverts/X/XInvertButton
@onready var y_invert_button := $PanelContainer/MarginContainer/VBoxContainer/Inverts/Y/YInvertButton

@onready var x_sensitivity_slider := $PanelContainer/MarginContainer/VBoxContainer/Inverts2/X/XSensitivitySlider
@onready var y_sensitivity_slider := $PanelContainer/MarginContainer/VBoxContainer/Inverts2/Y/YSensitivitySlider

func _ready() -> void:
	fullscreen_toggle.pressed.connect(func() -> void: Settings.fullscreen = fullscreen_toggle.button_pressed)
	
	for key: String in Settings.RESOLUTION_SCALE_OPTIONS:
		resolution_scale.add_item(key)
		if (is_equal_approx(get_viewport().scaling_3d_scale, Settings.RESOLUTION_SCALE_OPTIONS[key])):
			resolution_scale.select(resolution_scale.item_count - 1)
	resolution_scale.item_selected.connect(func(index: int) -> void: get_viewport().scaling_3d_scale = Settings.RESOLUTION_SCALE_OPTIONS[resolution_scale.get_item_text(index)] )
	
	for key: String in Settings.SCALING_OPTIONS:
		resolution_scale_mode.add_item(key)
		if get_window().scaling_3d_mode == Settings.SCALING_OPTIONS[key]:
			resolution_scale_mode.select(resolution_scale_mode.item_count - 1)
	resolution_scale_mode.item_selected.connect(func(index: int) -> void: get_viewport().scaling_3d_mode = Settings.SCALING_OPTIONS[resolution_scale_mode.get_item_text(index)] )
	
	for key: String in Settings.HUD_ASPECT_RATIOS:
		hud_aspect_ratio.add_item(key)
		if (is_equal_approx(Settings.hud_aspect_ratio, Settings.HUD_ASPECT_RATIOS[key])):
			hud_aspect_ratio.select(hud_aspect_ratio.item_count - 1)
	hud_aspect_ratio.item_selected.connect(func(index: int) -> void: Settings.hud_aspect_ratio = Settings.HUD_ASPECT_RATIOS[hud_aspect_ratio.get_item_text(index)] )
	
	x_invert_button.pressed.connect(func() -> void: Settings.x_invert = x_invert_button.button_pressed)
	y_invert_button.pressed.connect(func() -> void: Settings.y_invert = y_invert_button.button_pressed)
	
	x_sensitivity_slider.value = Settings.x_sensitivity
	y_sensitivity_slider.value = Settings.y_sensitivity
	
	fov_slider.value = Settings.fov

func _process(_delta: float) -> void:
	fullscreen_toggle.button_pressed = Settings.fullscreen
	var window := get_window()
	if window:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if Settings.fullscreen else Window.MODE_WINDOWED
		
	fov_text.text = "FOV: %d" % (int(fov_slider.value))
	Settings.fov = fov_slider.value
	
	Settings.x_sensitivity = x_sensitivity_slider.value
	Settings.y_sensitivity = y_sensitivity_slider.value
	
	x_invert_button.button_pressed = Settings.x_invert
	y_invert_button.button_pressed = Settings.y_invert
