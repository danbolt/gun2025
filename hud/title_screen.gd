class_name TitleScreen extends HUDRoot

signal new_game_selected()

@onready var new_game_button: Button = %NewGameButton
@onready var exit_button: Button = %ExitToDesktopButton

func _ready() -> void:
	new_game_button.pressed.connect(new_game_selected.emit)
	exit_button.pressed.connect(func() -> void: get_tree().quit() )
	
	# We can't exit to the desktop if we're on a web export
	if OS.get_name() == "Web":
		exit_button.queue_free()
	
	new_game_button.grab_focus()
