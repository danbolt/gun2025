@tool
class_name ShootType extends TouchObject

@onready var fov_cone: Area3D = %FOVCone

var aggro_target: PlayerController = null

var shoot_time: float = 0.0
var shoot_period: float = 2.5

var cancel_bonus: float = 5.0

@onready var animation_player: AnimationPlayer = $shoot_gremlin/AnimationPlayer
@onready var skeleton: Skeleton3D = $shoot_gremlin/shoot_armature/Skeleton3D

func on_projectile_struck() -> void:
	get_tree().call_group("listen_for_score_events", "score_event", ScoreTable.SCORE_EVENT_HIT_PROJECTILE)
	
	cancel_bonus = max(1.0, cancel_bonus - 1.0)

func _ready() -> void:
	super._ready()
	shoot_time = shoot_period * 0.5
	
	cancel_bonus = 5.0
	
	arte_view.damaged.connect(on_shooter_damaged)
	
	animation_player.play("idle")
	animation_player.animation_finished.connect(func(anim_name: String) -> void: if anim_name == "shoot": animation_player.play("idle") )
	
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if fov_cone and aggro_target == null:
		if fov_cone.has_overlapping_bodies():
			for intruder: Node3D in fov_cone.get_overlapping_bodies():
				
				## TODO: optimize this
				var query := PhysicsRayQueryParameters3D.create(position, intruder.position, 1, [self])
				var space_state := get_world_3d().direct_space_state
				var result := space_state.intersect_ray(query)
				if result.has("collider"):
					continue
					
				aggro_target = intruder
				get_tree().call_group("sound_effect_listener", "play_3d_one_shot", Gameplay.GremlinSound.AggroA, global_position)
	
	
	
	if aggro_target != null and not aggro_target.is_knocked_back:
		look_at(aggro_target.position, Vector3.UP, true)
		shoot_time += delta
		if shoot_time >= shoot_period:
			shoot_time -= shoot_period
			
			var bone_id := skeleton.find_bone("bazooka")
			var bone_position := skeleton.get_bone_global_pose(bone_id)
			var global_bone_pos : Vector3 = skeleton.to_global(bone_position.origin)
			
			var direction_to_target: Vector3 = (aggro_target.position - global_bone_pos).normalized()
			var new_projectile: TouchObject = preload("res://components/shoot_projectile.tscn").instantiate()
			get_parent().add_child(new_projectile)
			var mask: int = 1
			var count := randi_range(0, 3)
			mask = mask << count
			new_projectile.mask_flags = mask
			new_projectile.velocity = direction_to_target * 20.0
			new_projectile.bonus = cancel_bonus
			new_projectile.position =global_bone_pos
			new_projectile.no_gravity = true
			new_projectile.damaged.connect(on_projectile_struck)
			new_projectile.no_score_on_kill = true
			new_projectile.queue_free_on_collision = true
			get_tree().call_group("sound_effect_listener", "play_3d_one_shot", Gameplay.GremlinSound.ShootSound, new_projectile.position, basis)
			
			animation_player.play("shoot")
			
	
	super._physics_process(delta)
	

func on_shooter_damaged(intruder: Node3D) -> void:
	
	get_tree().call_group("sound_effect_listener", "play_3d_one_shot", Gameplay.GremlinSound.DeathSound, global_position)
	var direction_to_intruder := (position - intruder.position).normalized()
	
	var slice_a := preload("res://source_mesh/shoot_gremlin_slice_a.blend").instantiate() as Node3D
	slice_a.position = Vector3.DOWN * 0.5
	var slice_b := preload("res://source_mesh/shoot_gremlin_slice_b.blend").instantiate() as Node3D
	
	var a_object := RigidBody3D.new()
	a_object.position = position + direction_to_intruder
	a_object.collision_layer = 0
	a_object.collision_mask = 1
	a_object.mass  = 0.01
	a_object.physics_material_override = preload("res://physics_materials/sliced.tres")
	var a_shape := CollisionShape3D.new()
	a_shape.shape = CapsuleShape3D.new()
	(a_shape.shape as CapsuleShape3D).radius = 0.25
	(a_shape.shape as CapsuleShape3D).height = 0.7
	a_object.add_child(a_shape)
	a_object.add_child(slice_a)
	get_parent().add_child(a_object)
	a_object.apply_impulse((direction_to_intruder * randf_range(20.0, 30.0)).rotated(Vector3.UP, randf_range(-0.2, 0.2)) + Vector3(0.0, 28.0, 0.0))
	a_object.rotation = Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI))
	a_object.sleeping_state_changed.connect(a_object.queue_free)
	
	var b_object := RigidBody3D.new()
	b_object.position = position + direction_to_intruder
	b_object.collision_layer = 0
	b_object.collision_mask = 1
	b_object.mass  = 0.01
	b_object.physics_material_override = preload("res://physics_materials/sliced.tres")
	var b_shape := CollisionShape3D.new()
	b_shape.shape = CapsuleShape3D.new()
	(b_shape.shape as CapsuleShape3D).radius = 0.25
	(b_shape.shape as CapsuleShape3D).height = 0.7
	b_object.add_child(b_shape)
	b_object.add_child(slice_b)
	get_parent().add_child(b_object)
	b_object.apply_impulse((direction_to_intruder * randf_range(20.0, 30.0)).rotated(Vector3.UP, randf_range(-0.2, 0.2)) + Vector3(0.0, 20.0, 0.0))
	b_object.rotation = Vector3(randf_range(-PI, PI), randf_range(-PI, PI), randf_range(-PI, PI))
	b_object.sleeping_state_changed.connect(b_object.queue_free)
