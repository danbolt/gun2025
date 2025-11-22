extends Node

@export var override_aspect_ratio: bool = false

@export var hud_aspect_ratio: float = 16.0 / 9.0

@export var fullscreen: bool = false

const ASPECT_RATIO_OPTIONS: Dictionary[String, float] = {
	"16:9": 16.0 / 9.0,
	"4:3": 4.0 / 3.0
}

const RESOLUTION_SCALE_OPTIONS: Dictionary[String, float] = {
	"100%": 1.0,
	"75%": 0.75,
	"50%": 0.5,
	"25%": 0.25,
	"12.5%": 0.125,
}
