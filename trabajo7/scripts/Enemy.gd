extends CharacterBody2D

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

@export var target : Node2D
@export var timer_label : Control

var go_reverse = false

var acceleration = Vector2.ZERO
var steer_direction

func _physics_process(delta):
	acceleration = Vector2.ZERO
	ai_chase_target(delta)
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		if collision.get_collider().is_in_group("wall"):
			if not go_reverse: 
				$Timer.start()
				
			go_reverse = not go_reverse
			
	timer_label.text = var_to_str($Timer.time_left)
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
	
func ai_chase_target(delta):
	var direction_to_target = (target.position - position).normalized()
	var angle_to_target = - direction_to_target.angle_to(transform.x)

	if angle_to_target > deg_to_rad(steering_angle):
		steer_direction = deg_to_rad(steering_angle)
	elif angle_to_target < -deg_to_rad(steering_angle):
		steer_direction = -deg_to_rad(steering_angle)
	else:
		steer_direction = angle_to_target
		
	if go_reverse:
		steer_direction *= -1

	var distance_to_target = position.distance_to(target.position)

	if distance_to_target > 10:
		if(go_reverse):
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
	rotation = new_heading.angle()


func _on_timer_timeout():
	go_reverse = false
