class_name Camera
extends Camera3D

@export var target: Node3D
@export var offset: Vector3
@export var smooth_speed: float

func _process(delta):
	if target != null:
		transform.origin = lerp(transform.origin, target.transform.origin - offset, smooth_speed * delta)

		# Smoothly interpolate the camera's rotation to match the target's rotation
		#var target_rotation = target.transform.basis.get_rotation_quaternion()
		#var current_rotation = transform.basis.get_rotation_quaternion()
		#transform.basis = Basis(current_rotation.slerp(target_rotation, smooth_speed * delta))
