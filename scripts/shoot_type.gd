@tool
class_name ShootType extends TouchObject

@onready var fov_cone: Area3D = %FOVCone

var aggro_target: PlayerController = null

var shoot_time: float = 0.0
var shoot_period: float = 2.5

func on_projectile_struck() -> void:
	get_tree().call_group("listen_for_score_events", "score_event", ScoreTable.SCORE_EVENT_HIT_PROJECTILE)

func _ready() -> void:
	super._ready()
	shoot_time = shoot_period * 0.5
	
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if fov_cone and aggro_target == null:
		if fov_cone.has_overlapping_bodies():
			for intruder: Node3D in fov_cone.get_overlapping_bodies():
				aggro_target = intruder
	
	
	
	if aggro_target != null and not aggro_target.is_knocked_back:
		look_at(aggro_target.position, Vector3.UP, true)
		shoot_time += delta
		if shoot_time >= shoot_period:
			shoot_time -= shoot_period
			
			var direction_to_target: Vector3 = (aggro_target.position - position).normalized()
			var new_projectile: TouchObject = preload("res://components/shoot_projectile.tscn").instantiate()
			get_parent_node_3d().add_child(new_projectile)
			var mask: int = 1
			var count := randi_range(0, 3)
			mask = mask << count
			new_projectile.mask_flags = mask
			new_projectile.velocity = direction_to_target * 20.0
			new_projectile.bonus = 0.8
			new_projectile.position = position
			new_projectile.no_gravity = true
			new_projectile.damaged.connect(on_projectile_struck)
	
	super._physics_process(delta)
	
