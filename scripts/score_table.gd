extends Node

@export var current_multiplier: float = 1.0

class ScoreEvent extends RefCounted:
	var _bonus: int = 0
	var message: String = ""
	
	var bonus: int:
		get:
			return int(_bonus * ScoreTable.current_multiplier)
	
	func _init(new_bonus: int, new_message: String) -> void:
		self._bonus = new_bonus
		self.message = new_message
	
@onready var SCORE_EVENT_ENEMY_KILL: ScoreEvent = ScoreEvent.new(100, "Gremlin Slain")
@onready var SCORE_EVENT_MIDAIR_STRIKE: ScoreEvent = ScoreEvent.new(50, "Midair Strike")
@onready var SCORE_EVENT_HIT_PROJECTILE: ScoreEvent = ScoreEvent.new(50, "Projectile Cancel")
@onready var SCORE_EVENT_PLAYER_STRUCK: ScoreEvent = ScoreEvent.new(-10, "Struck by a Gremlin")
