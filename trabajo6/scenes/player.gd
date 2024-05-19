class_name Player
extends CharacterBody3D

@export var speed : float = 5.0  # Speed of the character
@export var wall_tag : String = "Terrain"  # Tag to identify wall objects

const DOUBLETAP_DELAY = .25
var doubletap_time = DOUBLETAP_DELAY
var last_keycode:String = ""

func _physics_process(delta):
	walk()
	handle_doubletap(delta)

func handle_doubletap(delta):
	doubletap_time -= delta
	
	if Input.is_action_just_pressed("ui_up"):
		check_doubletap("ui_up")
	if Input.is_action_just_pressed("ui_down"):
		check_doubletap("ui_down")
	if Input.is_action_just_pressed("ui_left"):
		check_doubletap("ui_left")
	if Input.is_action_just_pressed("ui_right"):
		check_doubletap("ui_right")	
		
func check_doubletap(current_action:String):
	if last_keycode == current_action and doubletap_time >= 0: 
		print("DOUBLETAP: ", current_action)
		last_keycode = ""
	doubletap_time = DOUBLETAP_DELAY
	last_keycode = current_action
		
func walk():
	var direction = Vector3.ZERO  # Initialize direction vector

	if Input.is_action_pressed("ui_up"):
		direction.z -= 1
	if Input.is_action_pressed("ui_down"):
		direction.z += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	direction = direction.normalized() * speed  # Normalize to prevent faster diagonal movement and scale by speed

	velocity.x = direction.x
	velocity.z = direction.z

	# Move the character and get the number of collisions
	move_and_slide()

	check_wall_collisions()

func check_wall_collisions():
	# Check for collisions
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() and collision.get_collider().is_in_group(wall_tag):
			# Determine the direction of the wall collision
			var collision_normal = collision.get_normal()
			var wall_direction = determine_wall_direction(collision_normal)
			on_wall_collision(collision.get_collider(), wall_direction)

func determine_wall_direction(collision_normal: Vector3) -> String:
	if collision_normal.z > 0.5:
		return "up"
	elif collision_normal.z < -0.5:
		return "down"
	elif collision_normal.x > 0.5:
		return "left"
	elif collision_normal.x < -0.5:
		return "right"
	else:
		return "unknown"

func on_wall_collision(collider, wall_direction: String):
	print("Collided with a wall on the ", wall_direction, " side.")
	# Add your logic here based on the direction of the wall collision
