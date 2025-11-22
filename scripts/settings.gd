extends Node

@export var override_aspect_ratio: bool = false

@export var hud_aspect_ratio: float = 16.0 / 9.0

const ASPECT_RATIO_OPTIONS: Dictionary[String, float] = {
	"16:9": 16.0 / 9.0,
	"4:3": 4.0 / 3.0
}
