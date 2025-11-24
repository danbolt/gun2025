extends Control

@onready var resume_button := %ResumeButton
@onready var exit_game_button := %ExitGameButton

func on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	exit_game_button.focus_neighbor_bottom = resume_button.get_path()
	resume_button.focus_neighbor_top = exit_game_button.get_path()
	
	resume_button.pressed.connect(func () -> void: get_tree().paused = !get_tree().paused)
	exit_game_button.pressed.connect(func () -> void: get_tree().quit())
	
	visibility_changed.connect(on_visibility_changed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tree := get_tree()
	if tree != null:
		visible = tree.paused
