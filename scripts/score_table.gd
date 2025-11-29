extends Node


class ScoreEvent extends RefCounted:
	var bonus: int = 0
	var message: String = ""
	
	func _init(new_bonus: int, new_message: String) -> void:
		self.bonus = new_bonus
		self.message = new_message


	
@onready var SCORE_EVENT_ENEMY_KILL: ScoreEvent = ScoreEvent.new(100, "Gremlin Slain")
@onready var SCORE_EVENT_MIDAIR_STRIKE: ScoreEvent = ScoreEvent.new(50, "Midair Strike")
@onready var SCORE_EVENT_HIT_PROJECTILE: ScoreEvent = ScoreEvent.new(50, "Projectile Cancel")
@onready var SCORE_EVENT_PLAYER_STRUCK: ScoreEvent = ScoreEvent.new(-10, "Struck by a Gremlin")
