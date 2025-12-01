class_name LevelTitleCard extends HUDRoot

signal done()

@onready var pre_title: Label = %PreTitle
@onready var title: Label = %Title

func handle_flow() -> void:
	var tree := get_tree()
	
	var tween := tree.create_tween()
	tween.tween_property(pre_title, "visible_ratio", 1.0, pre_title.text.length() * 0.0718)
	tween.tween_interval(0.4)
	tween.tween_property(title, "visible_ratio", 1.0, title.text.length() * 0.0818)
	tween.tween_interval(2.0)
	
	await tween.finished
	
	done.emit()

func populate(pre_title_text: String, title_text: String) -> void:
	pre_title.text = pre_title_text
	title.text = title_text
	handle_flow.call_deferred()
