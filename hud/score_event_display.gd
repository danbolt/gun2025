@tool
class_name ScoreEventDisplay extends Control

@onready var score_text: Label = %ScoreText
@onready var score_value: Label = %ScoreValue

func do_score_event(ev: ScoreTable.ScoreEvent) -> void:
	score_text.text = ev.message
	score_value.text = "%+d" % ev.bonus
	
	var tree := get_tree()
	if tree:
		var text_tween := tree.create_tween()
		score_text.visible_ratio = 0.0
		text_tween.tween_property(score_text, "visible_ratio", 1.0, randf_range(0.311, 0.41))
		
		var value_tween := tree.create_tween()
		score_value.visible_ratio = 0.0
		value_tween.tween_property(score_value, "visible_ratio", 1.0, randf_range(0.6, 0.81))
