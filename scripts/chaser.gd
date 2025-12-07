@tool
class_name Chaser extends TouchObject

@export var run_speed: float = 4.0

@onready var fov_cone: Area3D = %FOVCone

@onready var navigation_agent := $NavigationAgent3D

@onready var animation_player: AnimationPlayer = $chase_gremlin/AnimationPlayer

var nav_tick: int = 0
var next_path_position: Vector3 = Vector3.ZERO

var aggro_target: PlayerController = null

func on_attacked_player(player: PlayerController) -> void:
	aggro_target = player
	navigation_agent.target_position = player.position
	next_path_position = player.position
	look_at(player.position, Vector3.UP, true)

func on_chaser_damaged(intruder: Node3D) -> void:
	
	var direction_to_intruder := (position - intruder.position).normalized()
	
	var slice_a := preload("res://source_mesh/chase_gremlin_slices.blend").instantiate() as Node3D
	slice_a.position = Vector3.DOWN * 0.5
	var slice_b := preload("res://source_mesh/chase_gremlin_slices_b.blend").instantiate() as Node3D
	
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


func _ready() -> void:
	super._ready()
	arte_view.attacked_player.connect(on_attacked_player)
	
	arte_view.damaged.connect(on_chaser_damaged)
	
	animation_player.play("idle")
	
func _process(delta: float) -> void:
	super._process(delta)

func _physics_process(delta: float) -> void:
	if fov_cone:
		if fov_cone.has_overlapping_bodies():
			for intruder: Node3D in fov_cone.get_overlapping_bodies():
				
				## TODO: optimize this
				var query := PhysicsRayQueryParameters3D.create(position, intruder.position, 1, [self])
				var space_state := get_world_3d().direct_space_state
				var result := space_state.intersect_ray(query)
				if result.has("collider"):
					continue
				
				nav_tick = randi_range(1, 40)
				aggro_target = intruder
				
				animation_player.play("chase")
				
				navigation_agent.target_position = intruder.position
				next_path_position = intruder.position
	
	if aggro_target != null and not aggro_target.is_knocked_back:
		nav_tick -= 1
		if nav_tick == 0:
			nav_tick = 40
			navigation_agent.target_position = aggro_target.position
			next_path_position = navigation_agent.get_next_path_position()
			next_path_position.y = position.y
		var direction_to_target := (next_path_position - position).normalized()
		velocity.x = direction_to_target.x * run_speed
		velocity.z = direction_to_target.z * run_speed
		if not next_path_position.is_equal_approx(position):
			look_at(next_path_position, Vector3.UP, true)
	else:
		velocity.x = 0
		velocity.z = 0 
		
		if aggro_target != null:
			look_at(aggro_target.position, Vector3.UP, true)
	
	super._physics_process(delta)
	
