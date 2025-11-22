class_name GameSettingsPanel extends Control

@onready var fullscreen_toggle := $PanelContainer/MarginContainer/VBoxContainer/FullscreenToggle
@onready var resolution_scale := $PanelContainer/MarginContainer/VBoxContainer/ResolutionScale
@onready var hud_aspect_ratio := $PanelContainer/MarginContainer/VBoxContainer/HUDAspectRatio

func _ready() -> void:
	fullscreen_toggle.pressed.connect(func() -> void: Settings.fullscreen = fullscreen_toggle.button_pressed)
	
	for key: String in Settings.RESOLUTION_SCALE_OPTIONS:
		resolution_scale.add_item(key)
	resolution_scale.item_selected.connect(func(index: int) -> void: get_window().scaling_3d_scale = Settings.RESOLUTION_SCALE_OPTIONS[resolution_scale.get_item_text(index)] )
	
	for key: String in Settings.HUD_ASPECT_RATIOS:
		hud_aspect_ratio.add_item(key)
		if (is_equal_approx(Settings.hud_aspect_ratio, Settings.HUD_ASPECT_RATIOS[key])):
			hud_aspect_ratio.select(hud_aspect_ratio.item_count - 1)
	hud_aspect_ratio.item_selected.connect(func(index: int) -> void: Settings.hud_aspect_ratio = Settings.HUD_ASPECT_RATIOS[hud_aspect_ratio.get_item_text(index)] )

func _process(_delta: float) -> void:
	fullscreen_toggle.button_pressed = Settings.fullscreen
	var window := get_window()
	if window:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if Settings.fullscreen else Window.MODE_WINDOWED
