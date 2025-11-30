class_name EndLevelScreen extends HUDRoot

signal continued()

@onready var panel_container: Control = %PanelContainer

@onready var stage_clear_title_text: Label = %StageClearTitleText
@onready var score_text: Label = %ScoreText
@onready var time_bonus_text: Label = %TimeBonusText
@onready var remaining_hp_text: Label = %RemainingHPBonusText
@onready var total_score_text: Label = %TotalScoreText

@onready var continue_button: Button = %ContinueButton

func on_continue_button_pressed() -> void:
	continued.emit()

func animate_steps() -> void:
	await get_tree().create_timer(0.8, true, true).timeout
	
	panel_container.visible = true
	
	await get_tree().create_timer(0.4, true, true).timeout
	score_text.visible = true
	await get_tree().create_timer(0.4, true, true).timeout
	time_bonus_text.visible = true
	await get_tree().create_timer(0.4, true, true).timeout
	remaining_hp_text.visible = true
	
	await get_tree().create_timer(0.8, true, true).timeout
	total_score_text.visible = true
	await get_tree().create_timer(0.4, true, true).timeout
	continue_button.disabled = false
	continue_button.visible = true
	continue_button.grab_focus()
	

func populate(end_score: int, time_bonus: int, remaining_hp: int) -> void:
	score_text.text = "Score: %06d" % end_score
	time_bonus_text.text = "Time Bonus: %06d" % time_bonus
	remaining_hp_text.text = "Remaining Health: %06d" % remaining_hp
	total_score_text.text = "Total Score: %06d" % (end_score + time_bonus + remaining_hp)
	
	animate_steps.call_deferred()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	continue_button.pressed.connect(on_continue_button_pressed)
