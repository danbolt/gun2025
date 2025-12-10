@tool
class_name Wizard extends TouchObject

@onready var animation_player: AnimationPlayer = $wizard_gremlin/AnimationPlayer

func on_wizard_killed() -> void:
	Dialogic.start(preload("res://timelines/killed_wizard.dtl")).process_mode = Node.PROCESS_MODE_ALWAYS
	#
	get_tree().call_group("listen_for_level_change", "level_cleared")

func _ready() -> void:
	super._ready()
	animation_player.play("idle")
	animation_player.process_mode = Node.PROCESS_MODE_ALWAYS
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	arte_view.damaged.connect(on_wizard_damaged)
	
func on_wizard_damaged(intruder: Node3D) -> void:
	on_wizard_killed.call_deferred()
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
