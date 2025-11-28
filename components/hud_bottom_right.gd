extends Control

@onready var move_icon: TextureRect = %MoveIcon
@onready var aim_icon: TextureRect = %AimIcon
@onready var sprint_icon: TextureRect = %SprintIcon
@onready var jump_icon: TextureRect = %JumpIcon
@onready var arte_icon0: TextureRect = %ArteIcon0
@onready var arte_icon1: TextureRect = %ArteIcon1
@onready var arte_icon2: TextureRect = %ArteIcon2
@onready var arte_icon3: TextureRect = %ArteIcon3

@onready var mystic_artes_input: Control = %"Mystic Artes Input"

func update_key_icons() -> void:
	if Settings.last_input_mode == Settings.LastUsedMode.KBD:
		move_icon.texture = InputSpriteMappings.MOVE_KEYS
		aim_icon.texture = InputSpriteMappings.AIM_MOUSE
		sprint_icon.texture = InputSpriteMappings.KEY_TEXTURES[KEY_SHIFT]
		jump_icon.texture = InputSpriteMappings.KEY_TEXTURES[KEY_SPACE]
		arte_icon0.texture = InputSpriteMappings.KEY_TEXTURES[InputSpriteMappings.ARTE_0_KEY]
		arte_icon1.texture = InputSpriteMappings.KEY_TEXTURES[InputSpriteMappings.ARTE_1_KEY]
		arte_icon2.texture = InputSpriteMappings.KEY_TEXTURES[InputSpriteMappings.ARTE_2_KEY]
		arte_icon3.texture = InputSpriteMappings.KEY_TEXTURES[InputSpriteMappings.ARTE_3_KEY]
	else:
		if Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.SWITCH:
			move_icon.texture = InputSpriteMappings.MOVE_STICK_SWITCH
			aim_icon.texture = InputSpriteMappings.AIM_STICK_SWITCH
			sprint_icon.texture = InputSpriteMappings.SPRINT_SWITCH
			jump_icon.texture = InputSpriteMappings.JUMP_SWITCH
			arte_icon0.texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[JOY_BUTTON_A]
			arte_icon1.texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[JOY_BUTTON_B]
			arte_icon2.texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[JOY_BUTTON_X]
			arte_icon3.texture = InputSpriteMappings.BUTTON_TEXTURES_SWITCH[JOY_BUTTON_Y]
		elif Settings.last_used_gamepad_type == Settings.LastUsedGamepadType.PLAYSTATION:
			move_icon.texture = InputSpriteMappings.MOVE_STICK_PLAYSTATION
			aim_icon.texture = InputSpriteMappings.AIM_STICK_PLAYSTATION
			sprint_icon.texture = InputSpriteMappings.SPRINT_PLAYSTATION
			jump_icon.texture = InputSpriteMappings.JUMP_PLAYSTATION
			arte_icon0.texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[JOY_BUTTON_A]
			arte_icon1.texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[JOY_BUTTON_B]
			arte_icon2.texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[JOY_BUTTON_X]
			arte_icon3.texture = InputSpriteMappings.BUTTON_TEXTURES_PLAYSTATION[JOY_BUTTON_Y]
		else:
			move_icon.texture = InputSpriteMappings.MOVE_STICK_XBOX
			aim_icon.texture = InputSpriteMappings.AIM_STICK_XBOX
			sprint_icon.texture = InputSpriteMappings.SPRINT_XBOX
			jump_icon.texture = InputSpriteMappings.JUMP_XBOX
			arte_icon0.texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[JOY_BUTTON_A]
			arte_icon1.texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[JOY_BUTTON_B]
			arte_icon2.texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[JOY_BUTTON_X]
			arte_icon3.texture = InputSpriteMappings.BUTTON_TEXTURES_XBOX[JOY_BUTTON_Y]

func _process(_delta: float) -> void:
	mystic_artes_input.visible = not Input.is_action_pressed("sprint")
	
	update_key_icons()
