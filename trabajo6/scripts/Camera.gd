class_name Camera
extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export var smooth_speed: float

func _process(delta):
	if target != null:
		transform.origin = lerp(transform.origin, target.transform.origin - offset, smooth_speed * delta)
