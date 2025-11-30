@tool
class_name Chaser extends TouchObject

@export var run_speed: float = 6.0

@onready var fov_cone: Area3D = %FOVCone

@onready var navigation_agent := $NavigationAgent3D

var nav_tick: int = 0
var next_path_position: Vector3 = Vector3.ZERO

var aggro_target: PlayerController = null

func on_attacked_player(player: PlayerController) -> void:
	aggro_target = player
	navigation_agent.target_position = player.position
	next_path_position = player.position
	look_at(player.position, Vector3.UP, true)

func _ready() -> void:
	super._ready()
	arte_view.attacked_player.connect(on_attacked_player)
	
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if fov_cone:
		if fov_cone.has_overlapping_bodies():
			for intruder: Node3D in fov_cone.get_overlapping_bodies():
				nav_tick = randi_range(1, 40)
				aggro_target = intruder
				
				navigation_agent.target_position = intruder.position
				next_path_position = intruder.position
	
	if aggro_target != null and not aggro_target.is_knocked_back:
		nav_tick -= 1
		if nav_tick == 0:
			nav_tick = 40
			navigation_agent.target_position = aggro_target.position
			next_path_position = navigation_agent.get_next_path_position()
		var direction_to_target := (next_path_position - position).normalized()
		velocity.x = direction_to_target.x * run_speed
		velocity.z = direction_to_target.z * run_speed
		look_at(next_path_position, Vector3.UP, true)
	else:
		velocity.x = 0
		velocity.z = 0 
		
		if aggro_target != null:
			look_at(aggro_target.position, Vector3.UP, true)
	
	super._physics_process(delta)
	
