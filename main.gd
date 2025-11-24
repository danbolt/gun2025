extends Node

@onready var gameplay := $Gameplay

func on_timeline_started() -> void:
	var tree := get_tree()
	if tree != null:
		tree.paused = true
		pass
		
func on_timeline_finished() -> void:
	var tree := get_tree()
	if tree != null:
		tree.paused = false
		pass

func _ready() -> void:
	gameplay.load_and_add_level("res://levels/indoor.tscn")
	
	Dialogic.timeline_started.connect(on_timeline_started)
	Dialogic.timeline_ended.connect(on_timeline_finished)
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var tree := get_tree()
	if tree == null:
		return
		
	if Input.is_action_just_pressed("ui_accept") and tree.paused == false:
		Dialogic.start("test").process_mode = Node.PROCESS_MODE_ALWAYS
		
	if Input.is_action_just_pressed("pause") and Dialogic.current_timeline == null:
		tree.paused = !tree.paused
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if !tree.paused else Input.MOUSE_MODE_VISIBLE
