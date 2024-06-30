extends CharacterBody2D

@export var wheel_base = 70
@export var steering_angle = 15
var aux_steering_angle
@export var engine_power = 900
@export var friction = -55
@export var drag = -0.06
@export var braking = -450
@export var max_speed_reverse = 250
@export var slip_speed = 400
@export var traction_fast = 2.5
@export var traction_slow = 10

var acceleration = Vector2.ZERO
var steer_direction

var bounce_velocity = Vector2.ZERO
@export var bounce_decay = 0.5
@export var bounce_strength_factor = 0.5

func _init():
	aux_steering_angle = steering_angle
	
func _physics_process(delta):
	acceleration = Vector2.ZERO
	get_input()
	apply_friction(delta)
	calculate_steering(delta)
	velocity += acceleration * delta
	
	if bounce_velocity.length() > 0.1:
		bounce_velocity *= bounce_decay
		velocity += bounce_velocity
		move_and_slide()
	else:
		bounce_velocity = Vector2.ZERO
		
	var collision = move_and_collide(velocity * delta)
	if collision:
		var collided = collision.get_collider()
		velocity = velocity.bounce(collision.get_normal())
		
		if collided.is_in_group('character'):
			var bounce_speed = velocity.length()
			var bounce_direction = (collided.position - position).normalized()
			collided.apply_bounce(bounce_speed, bounce_direction)
	
func apply_friction(delta):
	if acceleration == Vector2.ZERO and velocity.length() < 50:
		velocity = Vector2.ZERO
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	acceleration += drag_force + friction_force
	
func get_input():
	var turn = Input.get_axis("ui_left", "ui_right")
	steer_direction = turn * deg_to_rad(steering_angle)
	if Input.is_action_pressed("ui_up"):
		acceleration = transform.x * engine_power
	if Input.is_action_pressed("ui_down"):
		acceleration = transform.x * braking
		
	if Input.is_action_pressed("ui_accept"):
		drift()
	elif Input.is_action_just_released("ui_accept"):
		stop_drift()
	
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
#	velocity = new_heading * velocity.length()
	rotation = new_heading.angle()

func drift():
	steering_angle = aux_steering_angle * 2
	
func stop_drift():
	steering_angle = aux_steering_angle

func apply_bounce(speed, direction):
	bounce_velocity = direction * speed * bounce_strength_factor

func _on_front_area_body_entered(body):
	if body.has_method("receive_hit"):
		body.receive_hit()
