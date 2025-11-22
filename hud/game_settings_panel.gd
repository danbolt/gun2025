class_name GameSettingsPanel extends Control

@onready var fullscreen_toggle := $PanelContainer/MarginContainer/VBoxContainer/FullscreenToggle
@onready var resolution_scale := $PanelContainer/MarginContainer/VBoxContainer/ResolutionScale

func _ready() -> void:
	fullscreen_toggle.pressed.connect(func() -> void: Settings.fullscreen = fullscreen_toggle.button_pressed)
	
	for key: String in Settings.RESOLUTION_SCALE_OPTIONS:
		resolution_scale.add_item(key)
	resolution_scale.item_selected.connect(func(index: int) -> void: get_window().scaling_3d_scale = Settings.RESOLUTION_SCALE_OPTIONS[resolution_scale.get_item_text(index)] )

func _process(_delta: float) -> void:
	fullscreen_toggle.button_pressed = Settings.fullscreen
	var window := get_window()
	if window:
		window.mode = Window.MODE_EXCLUSIVE_FULLSCREEN if Settings.fullscreen else Window.MODE_WINDOWED
