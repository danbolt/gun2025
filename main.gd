extends Node

@onready var gameplay: Gameplay = null
@onready var gameplay_prefab := preload("res://components/gameplay.tscn")

@onready var curtains: Control = %Curtains

var curtains_value: float = 0.0
@export var curtains_open: bool = false

var current_score: int = 0

func on_player_death() -> void:
	await get_tree().create_timer(2.0, true, true).timeout
	curtains_open = false
	await get_tree().create_timer(1.5, true, true).timeout
	clear_old_level()
	show_title_screen()
	curtains_open = true

func score_event(event: ScoreTable.ScoreEvent) -> void:
	current_score += event.bonus
	if current_score < 0:
		current_score = 0
	gameplay.set_score_to_display(current_score)

func new_game_state() -> void:
	current_score = 0


func clear_old_level() -> void:
	if gameplay != null:
		gameplay.remove_level()
		gameplay.queue_free()
		remove_child(gameplay)
		gameplay = null

func new_level(next_level: String) -> void:
	gameplay = gameplay_prefab.instantiate()
	add_child(gameplay)
	move_child(curtains, get_child_count() - 1)
	gameplay.player_death.connect(on_player_death.call_deferred)
	gameplay.load_and_add_level("res://levels/%s.tscn" % next_level)

func wait_then_next(next_level: String) -> void:
	await get_tree().create_timer(1.5, true, true).timeout
	curtains_open = false
	await get_tree().create_timer(1.5, true, true).timeout
	var time_passed_in_gameplay := gameplay.seconds_passed_in_game_time
	var player_hp := gameplay.hp
	var time_bonus := maxi(int(time_passed_in_gameplay - 120), 0)
	clear_old_level()
	var new_results_screen: EndLevelScreen = preload("res://hud/end_level_screen.tscn").instantiate()
	add_child(new_results_screen)
	move_child(curtains, get_child_count() - 1)
	curtains_open = true
	curtains_value = 1.9
	new_results_screen.populate(current_score, time_bonus, int(player_hp))
	current_score = current_score + time_bonus + int(player_hp)
	await new_results_screen.continued
	curtains_open = false
	curtains_value = 0.0
	new_results_screen.queue_free()
	remove_child(new_results_screen)
	new_level(next_level)
	await get_tree().create_timer(0.5, true, true).timeout
	curtains_open = true
	gameplay.set_score_to_display(current_score)

func level_cleared(next_level: String) -> void:
	gameplay.level_clear()
	wait_then_next.call_deferred(next_level)

func show_title_screen() -> void:
	var new_title_screen: TitleScreen = preload("res://hud/title_screen.tscn").instantiate()
	add_child(new_title_screen)
	move_child(curtains, get_child_count() - 1)
	new_title_screen.new_game_selected.connect(start_new_game.call_deferred)
	
func start_new_game() -> void:
	curtains_open = false
	await get_tree().create_timer(1.1, true, true).timeout
	
	for child: Node in get_children():
		if child is TitleScreen:
			child.queue_free()
			remove_child(child)
			break
	
	new_game_state()
	new_level("palace")
	await get_tree().create_timer(0.2, true, true).timeout
	curtains_open = true

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
	
	Dialogic.timeline_started.connect(on_timeline_started)
	Dialogic.timeline_ended.connect(on_timeline_finished)
	Dialogic.process_mode = Node.PROCESS_MODE_ALWAYS
	
	show_title_screen()
	
	curtains_open = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	curtains_value = lerp(curtains_value, 1.9 if curtains_open else 0.0, 1.0 - pow(0.131, delta * 1.3))
	(curtains.material as ShaderMaterial).set_shader_parameter("t", curtains_value)
	
	var tree := get_tree()
	if tree == null:
		return
		
	var zone_cleared: bool = false
	if gameplay != null:
		if gameplay.arrived_at_exit:
			zone_cleared = true
		
	var can_pause: bool = true
	
	if (Dialogic.current_timeline != null):
		can_pause = false
		
	if zone_cleared:
		can_pause = false
		
	if gameplay != null and gameplay.player_has_died:
		can_pause = false
		
	if gameplay != null and gameplay.arrived_at_exit:
		can_pause = false
		
	if gameplay == null:
		can_pause = false
		
	if Input.is_action_just_pressed("pause") and can_pause:
		tree.paused = !tree.paused
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED if (!tree.paused and gameplay != null) else Input.MOUSE_MODE_VISIBLE
