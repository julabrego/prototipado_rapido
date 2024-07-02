class_name Enemy
extends CharacterBody2D

signal got_out_of_camera
signal got_in_camera
signal enemy_got_dizzy
signal enemy_is_no_more_dizzy

@export var wheel_base = 70
@export var steering_angle = 15
@export var engine_power = 900
@export var friction = -55
@export var drag = -0.06
@export var braking = -450
@export var max_speed_reverse = 250
@export var slip_speed = 400
@export var traction_fast = 2.5
@export var traction_slow = 10

@export var main_camera : Camera2D
@export var target : Node2D
@export var reverse_timer_label : Control
@export var blink_timer_label : Control
@export var bounce_label : Control

var can_move = false
var is_going_reverse = false
var is_dizzy = false

var acceleration = Vector2.ZERO
var steer_direction

var bounce_velocity = Vector2.ZERO
@export var bounce_decay = 0.9
@export var bounce_strength_factor = 0.5

var hits_received = 0
var is_in_camera = false

func _ready():
	$AnimationPlayer.play("Stopped")

func _physics_process(delta):
	acceleration = Vector2.ZERO

	if bounce_velocity.length() > 100.1:
		bounce_velocity *= bounce_decay
		velocity = bounce_velocity
	else:
		bounce_velocity = Vector2.ZERO
		ai_chase_target(delta)
		apply_friction(delta)
		calculate_steering(delta)
		velocity += acceleration * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		if collision.get_collider().is_in_group("character"):
			apply_bounce_to_other(collision.get_collider())
			
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().is_in_group("wall"):
			if not is_going_reverse: 
				$ReverseTimer.start()
				
			is_going_reverse = not is_going_reverse

	if hits_received > 3 and not is_dizzy:
		enemy_got_dizzy.emit()
		is_dizzy = true
		can_move = false
		$AnimationPlayer.play("Blink")
		$DizzyTimer.start()
		
	if is_dizzy and $DizzyTimer.time_left < 2:
		$AnimationPlayer.play("BlinkFast")
		
	reverse_timer_label.text = var_to_str($ReverseTimer.time_left)
	blink_timer_label.text = var_to_str($DizzyTimer.time_left)
	
	if is_node_out_of_camera(main_camera) and is_in_camera:
		is_in_camera = false
		got_out_of_camera.emit()
	if not is_node_out_of_camera(main_camera) and not is_in_camera:
		is_in_camera = true
		got_in_camera.emit()
		
	bounce_label.text = var_to_str(bounce_velocity)

func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force

func ai_chase_target(delta):
	var direction_to_target = (target.position - position).normalized()
	var angle_to_target = - direction_to_target.angle_to(transform.x)

	if not is_dizzy:
		if angle_to_target > deg_to_rad(steering_angle):
			steer_direction = deg_to_rad(steering_angle)
		elif angle_to_target < -deg_to_rad(steering_angle):
			steer_direction = -deg_to_rad(steering_angle)
		else:
			steer_direction = angle_to_target
		
	if is_going_reverse:
		steer_direction *= -1

	var distance_to_target = position.distance_to(target.position)

	if not is_dizzy and can_move:
		if distance_to_target > 10:
			if(is_going_reverse):
				acceleration = - transform.x * engine_power
			else:
				acceleration = transform.x * engine_power
		else:
			acceleration = Vector2.ZERO

func calculate_steering(delta):
	var rear_wheel = position - transform.x * wheel_base / 2.0
	var front_wheel = position + transform.x * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(steer_direction) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var traction = traction_slow
	if velocity.length() > slip_speed:
		traction = traction_fast
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = lerp(velocity, new_heading * velocity.length(), traction * delta)
	if d < 0:
		velocity = -new_heading * min(velocity.length(), max_speed_reverse)
		
	if bounce_velocity.length() <= 0.1:
		rotation = new_heading.angle()

func apply_bounce(speed, direction):
	bounce_velocity = direction * speed * bounce_strength_factor

func apply_bounce_to_other(other):
	var bounce_speed = velocity.length()
	var bounce_direction = (other.position - position).normalized()
	other.apply_bounce(bounce_speed, bounce_direction)
		
func _on_timer_timeout():
	$ReverseTimer.stop()
	is_going_reverse = false
	
func receive_hit():
	hits_received += 1

func _on_front_area_body_entered(body):
	if body.is_in_group("player"):
		print("Enemy collided with player")

func _on_dizzy_timer_timeout():
	$AnimationPlayer.play("Stopped")
	$DizzyTimer.stop()
	hits_received = 0
	can_move = true
	is_dizzy = false
	enemy_is_no_more_dizzy.emit()

func is_node_out_of_camera(camera: Camera2D) -> bool:
	var viewport_size = camera.get_viewport_rect().size
	var viewport_center = camera.global_position
	var viewport_rect = Rect2(viewport_center - (viewport_size / 2), viewport_size)
	var node_pos = global_position

	return not viewport_rect.has_point(node_pos)
