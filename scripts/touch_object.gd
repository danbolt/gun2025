@tool
class_name TouchObject extends CharacterBody3D

@export_flags_2d_physics var spawn_flags: int = 0
@export_flags_2d_physics var mask_flags: int = 15

var arte_view: ArteView = null

func _func_godot_apply_properties(properties: Dictionary) -> void:
	spawn_flags = int(properties.get("spawnflags", 0))
	mask_flags = int(properties.get("maskflags", 15))

func _add_arte_view() -> void:
	if arte_view == null:
		arte_view = preload("res://components/atre_view.tscn").instantiate()
		add_child(arte_view)
		arte_view.set_flags(spawn_flags)
		arte_view.set_mask(mask_flags)
	
func _ready() -> void:
	_add_arte_view()
	arte_view.damaged.connect(queue_free)
	
func _process(_delta: float) -> void:
	arte_view.set_mask(mask_flags)

func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
