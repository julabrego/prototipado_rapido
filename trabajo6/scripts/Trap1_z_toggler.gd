extends StaticBody3D

@export var level_controller: Node3D
@export var shadow_mode_z: Vector3
@export var body_mode_z: Vector3

func _process(delta):
	if level_controller.shadow_mode:
		position = shadow_mode_z
	else:
		position = body_mode_z
