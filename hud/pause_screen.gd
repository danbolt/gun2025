extends Control

@onready var resume_button := %ResumeButton
@onready var to_title_screen_button := %ToTitleScreen
@onready var exit_game_button := %ExitGameButton

func on_visibility_changed() -> void:
	if visible:
		resume_button.grab_focus()

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	exit_game_button.focus_neighbor_bottom = resume_button.get_path()
	resume_button.focus_neighbor_top = exit_game_button.get_path()
	
	resume_button.pressed.connect(func () -> void: get_tree().paused = !get_tree().paused)
	to_title_screen_button.pressed.connect(func () -> void: get_tree().call_group("listen_for_level_change", "exit_gameplay_to_title_screen") )
	exit_game_button.pressed.connect(func () -> void: get_tree().quit())
	
	if OS.get_name() == "Web":
		exit_game_button.queue_free()
	
	visibility_changed.connect(on_visibility_changed)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tree := get_tree()
	if tree != null and Dialogic.current_timeline == null:
		visible = tree.paused
