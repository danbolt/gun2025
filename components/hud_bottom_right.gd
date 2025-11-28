extends Control

@onready var move_icon: TextureRect = %MoveIcon
@onready var sprint_icon: TextureRect = %SprintIcon
@onready var jump_icon: TextureRect = %JumpIcon
@onready var arte_icon0: TextureRect = %ArteIcon0
@onready var arte_icon1: TextureRect = %ArteIcon1
@onready var arte_icon2: TextureRect = %ArteIcon2
@onready var arte_icon3: TextureRect = %ArteIcon3

func _process(_delta: float) -> void:
	if Settings.last_input_mode == Settings.LastUsedMode.KBD:
		pass
