class_name ShadowCamera
extends Camera3D

@export var level_controller: Node3D
@export var shadow_mode_z: Vector3
@export var body_mode_z: Vector3

var smooth_speed = 5

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if level_controller.shadow_mode:
		transform.origin = lerp(transform.origin, shadow_mode_z, smooth_speed * delta)
	else:
		transform.origin = lerp(transform.origin, body_mode_z, smooth_speed * delta)
