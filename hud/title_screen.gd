class_name TitleScreen extends HUDRoot

signal new_game_selected()

@onready var new_game_button: Button = %NewGameButton
@onready var exit_button: Button = %ExitToDesktopButton

func _ready() -> void:
	new_game_button.pressed.connect(new_game_selected.emit)
	exit_button.pressed.connect(func() -> void: get_tree().quit() )
	
	new_game_button.grab_focus()
