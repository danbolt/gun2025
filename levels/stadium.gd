extends Node3D

@onready var background_music: AudioStreamPlayer = %BackgroundMusic

func play_music_after_delay(seconds: float) -> void:
	await get_tree().create_timer(seconds, false).timeout
	
	background_music.play()

func _ready() -> void:
	play_music_after_delay(0.8)
