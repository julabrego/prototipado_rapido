extends Node3D

@export var shadow_mode = true
var can_toggle_mode = true
var playing = true
var time = 0
var end_hud

func _ready():
	var end_hud_preload = preload("res://scenes/UI/EndHUD.tscn")
	end_hud = end_hud_preload.instantiate()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and can_toggle_mode:
		shadow_mode = not shadow_mode
		
func end_game():
	playing = false
	end_hud.update_time(time)
	$"../HUD".queue_free()
	add_child(end_hud)

func _on_area_3d_body_entered(body):
	if body.is_in_group('Player'):
		can_toggle_mode = false

func _on_area_3d_body_exited(body):
	if body.is_in_group('Player'):
		can_toggle_mode = true

func _on_exit_area_body_entered(body):
	if body.is_in_group('Player'):
		end_game()

func _on_timer_timeout():
	if playing:
		time+=1
		$"../HUD".update_time(time)
