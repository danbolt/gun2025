@tool
class_name InputIcon extends Node3D

@onready var sprite_3d: Sprite3D = $Sprite3D

@export var pressed: bool = false

@export var associated_key: Key = Key.KEY_Q
@export var associated_button: JoyButton = JoyButton.JOY_BUTTON_A

func refresh_input_icons() -> void:
	var candidate_texture: Texture2D = InputSpriteMappings.UNKNOWN_TEXTURE if pressed else InputSpriteMappings.UNKNOWN_TEXTURE_OUTLINE
	
	if Settings.last_input_mode == Settings.LastUsedMode.KBD:
		if pressed and InputSpriteMappings.KEY_TEXTURES.has(associated_key):
			candidate_texture = InputSpriteMappings.KEY_TEXTURES[associated_key]
		elif not pressed and InputSpriteMappings.KEY_TEXTURES_OUTLINE.has(associated_key):
			candidate_texture = InputSpriteMappings.KEY_TEXTURES_OUTLINE[associated_key]
	else:
		if Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.XBOX:
			if pressed and InputSpriteMappings.BUTTON_TEXTURES_XBOX.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[associated_button]
			elif not pressed and InputSpriteMappings.BUTTON_TEXTURES_XBOX_OUTLINE.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX_OUTLINE[associated_button]
		elif Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.SWITCH:
			if pressed and InputSpriteMappings.BUTTON_TEXTURES_SWITCH.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[associated_button]
			elif not pressed and InputSpriteMappings.BUTTON_TEXTURES_SWITCH_OUTLINE.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH_OUTLINE[associated_button]
		elif Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.PLAYSTATION:
			if pressed and InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[associated_button]
			elif not pressed and InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION_OUTLINE.has(associated_button):
				candidate_texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION_OUTLINE[associated_button]
	
	sprite_3d.texture = candidate_texture

func _ready() -> void:
	refresh_input_icons()

func _process(_delta: float) -> void:
	refresh_input_icons()
