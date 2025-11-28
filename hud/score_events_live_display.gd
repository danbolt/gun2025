extends VBoxContainer

func wait_then_kill_event(score_event_display: ScoreEventDisplay) -> void:
	await get_tree().create_timer(2.0, false, false).timeout
	score_event_display.queue_free()
	remove_child(score_event_display)
	

func score_event(event: ScoreTable.ScoreEvent) -> void:
	var new_score_event: ScoreEventDisplay = preload("res://hud/score_event_display.tscn").instantiate()
	add_child(new_score_event)
	new_score_event.do_score_event(event)
	wait_then_kill_event.call_deferred(new_score_event)
