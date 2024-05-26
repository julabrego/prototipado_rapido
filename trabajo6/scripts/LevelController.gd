extends Node3D

@export var shadow_mode = true
var can_toggle_mode = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and can_toggle_mode:
		shadow_mode = not shadow_mode

func _on_area_3d_body_entered(body):
	if body.is_in_group('Player'):
		can_toggle_mode = false

func _on_area_3d_body_exited(body):
	if body.is_in_group('Player'):
		can_toggle_mode = true
