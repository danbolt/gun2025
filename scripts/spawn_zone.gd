@tool
class_name SpawnZone extends CollisionShape3D

@export_range(0.0, 0.6, 0.01) var spawn_ratio: float = 0.5 

var _idle_val: float = 1.0
var _chase_val: float = 0.0
var _shoot_val: float = 0.0

const IDLE_PREFAB := preload("res://components/idler.tscn")
const CHASER_PREFAB := preload("res://components/chaser.tscn")
const SHOOT_PREFAB := preload("res://components/shoot_type.tscn")
	
@export_tool_button("populate", "CharacterBody3D") var populate = populate_with_monsters
@export_tool_button("clean", "CharacterBody3D") var clean = clean_monsters

func clean_monsters() -> void:
	for child in get_children(true):
		if child is TouchObject:
			child.queue_free()
			remove_child(child)

func populate_with_monsters() -> void:
	
	# remove any old ones
	clean_monsters()
			
	var min_extents := Vector3.ZERO
	var max_extents := Vector3.ZERO 
	var size_found: bool = false
	var xz_area: int = 0
	
	# Ensure scale is proper
	scale = Vector3.ONE
	
	if shape:
		var box_shape := (shape as BoxShape3D)
		min_extents = box_shape.size / -2.0
		max_extents = box_shape.size / 2.0
		xz_area = int(box_shape.size.x * box_shape.size.z)
		size_found = true
				
	if size_found:
		var desired_count := int(sqrt(xz_area) * spawn_ratio)
		for i: int in desired_count:
			var roll := randf()
			
			var new_monster: TouchObject = null
			if roll > _idle_val + _chase_val:
				new_monster = SHOOT_PREFAB.instantiate()
			elif roll > idle_val:
				new_monster = CHASER_PREFAB.instantiate()
			else:
				new_monster = IDLE_PREFAB.instantiate()
			
			var random_position_to_spawn := Vector3(randf_range(min_extents.x, max_extents.x), max_extents.y, -1.0 * randf_range(min_extents.z, max_extents.z))
			new_monster.position = global_position + (basis * random_position_to_spawn)
			new_monster.rotate_y(randf() * TAU)
			new_monster.mask_flags = randi_range(1, 15)
			new_monster.spawn_flags = randi_range(0, 15)
			
			add_child(new_monster)
		

@export_range(0.0, 1.0, 0.01) var idle_val: float:
	get:
		return _idle_val
	set(value):
		value = clamp(value, 0.0, 1.0)
		var other_ratio_prev := _chase_val + _shoot_val
		var new_remainder := 1.0 - value
		if other_ratio_prev > 0:
			_shoot_val = _shoot_val / other_ratio_prev * new_remainder
			_chase_val = _chase_val / other_ratio_prev * new_remainder
		
		_idle_val = value
@export_range(0.0, 1.0, 0.01) var chase_val: float:
	get:
		return _chase_val
	set(value):
		value = clamp(value, 0.0, 1.0)
		var other_ratio_prev := _idle_val + _shoot_val
		var new_remainder := 1.0 - value
		if other_ratio_prev > 0:
			_shoot_val = _shoot_val / other_ratio_prev * new_remainder
			_idle_val = _idle_val / other_ratio_prev * new_remainder
			
		_chase_val = value
@export_range(0.0, 1.0, 0.01) var shoot_val: float:
	get:
		return _shoot_val
	set(value):
		value = clamp(value, 0.0, 1.0)
		var other_ratio_prev := _idle_val + _chase_val
		var new_remainder := 1.0 - value
		if other_ratio_prev > 0:
			_chase_val = _chase_val / other_ratio_prev * new_remainder
			_idle_val = _idle_val / other_ratio_prev * new_remainder
			
		_shoot_val = value

func _ready_editor() -> void:
	if shape == null:
		shape = BoxShape3D.new()
		shape.size = Vector3(10.0, 3.0, 10.0)

func _ready() -> void:
	if Engine.is_editor_hint():
		_ready_editor()
	else:
		populate_with_monsters()

func _process_editor() -> void:
	var sum := (idle_val + chase_val + shoot_val)
	if sum < 1.0 and sum > 0.0:
		idle_val = idle_val / sum
		chase_val = chase_val / sum
		shoot_val = shoot_val / sum
	elif is_zero_approx(sum):
		idle_val = 1.0

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		_process_editor()
