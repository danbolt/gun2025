extends Node

enum LastUsedMode {
	KBD,
	GAMEPAD
}
@export var last_input_mode: LastUsedMode = LastUsedMode.KBD

enum LastUsedGamepadType {
	XBOX,
	SWITCH,
	PLAYSTATION,
}
@export var last_used_gamepad_type: LastUsedGamepadType = LastUsedGamepadType.XBOX

@export var hud_aspect_ratio: float = -1.0

@export var fullscreen: bool = false

const HUD_ASPECT_RATIOS: Dictionary[String, float] = {
	"Full HUD": -1.0,
	"16:9": 16.0 / 9.0,
	"4:3": 4.0 / 3.0,
	"21:9": 21.0 / 9.0,
	"32:9": 32.0 / 9.0,
}

const RESOLUTION_SCALE_OPTIONS: Dictionary[String, float] = {
	"100%": 1.0,
	"75%": 0.75,
	"50%": 0.5,
	"25%": 0.25,
	"12.5%": 0.125,
}

const SCALING_OPTIONS: Dictionary[String, Viewport.Scaling3DMode] = {
	"Bilinear":  Viewport.Scaling3DMode.SCALING_3D_MODE_BILINEAR,
	"FSR": Viewport.Scaling3DMode.SCALING_3D_MODE_FSR,
	"FSR2": Viewport.Scaling3DMode.SCALING_3D_MODE_FSR2,
}

@export var fov: float = 72.0
var _prev_fov: float = -1.0

func get_mapping_for_device_name(device_name: String) -> LastUsedGamepadType:
	if device_name.contains("Xbox") or device_name.contains("X-Box"):
		return LastUsedGamepadType.XBOX
	elif device_name == "Nintendo Switch Pro Controller":
		return LastUsedGamepadType.SWITCH
	elif device_name.contains("PS3") or device_name.contains("PS4") or device_name.contains("PS5") or device_name.contains("DualSense") or device_name.contains("DualShock") or device_name.contains("DUALSHOCK"):
		return LastUsedGamepadType.PLAYSTATION

	return LastUsedGamepadType.XBOX

func _input(event: InputEvent) -> void:
	if event is InputEventKey or event is InputEventMouseButton or event is InputEventMouseMotion:
		last_input_mode = LastUsedMode.KBD
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		last_input_mode = LastUsedMode.GAMEPAD
		
		last_used_gamepad_type = get_mapping_for_device_name(Input.get_joy_name(event.device))
		

func _process(_delta: float) -> void:
	if not is_equal_approx(fov, _prev_fov):
		get_tree().call_group("listen_for_fov_updates", "update_fov", fov)
		_prev_fov = fov
