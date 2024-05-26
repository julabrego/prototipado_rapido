class_name Player
extends CharacterBody3D

@export var speed : float = 5.0  # Speed of the character
@export var wall_tag : String = "Terrain"  # Tag to identify wall objects

const DOUBLETAP_DELAY = .25
var doubletap_time = DOUBLETAP_DELAY
var last_keycode:String = ""
var is_rotating:bool = false
var target_rotation
var target_direction
var current_normal = Vector3.UP  # Initial normal is up (ground)

func _ready():
	target_rotation = rotation

func _physics_process(delta):
	doubletap_time -= delta
	
	if is_rotating:
		if target_direction == 'down' :
			rotation.x -= 0.02
		elif target_direction == 'up':
			rotation.x += 0.02
		elif target_direction == 'left':
			rotation.z -= 0.02
		elif target_direction == 'right':
			rotation.z += 0.02
		
		if abs(round(fmod(rad_to_deg(rotation.x), 90.0))) < 2 and abs(round(fmod(rad_to_deg(rotation.y), 90.0))) < 2 and abs(round(fmod(rad_to_deg(rotation.z), 90.0))) < 2 :
			is_rotating = false
			align_with_surface(current_normal)
			
	else:
		walk()

func handle_doubletap():
	if Input.is_action_just_pressed("ui_up"):
		return check_doubletap("ui_up")
	if Input.is_action_just_pressed("ui_down"):
		return check_doubletap("ui_down")
	if Input.is_action_just_pressed("ui_left"):
		return check_doubletap("ui_left")
	if Input.is_action_just_pressed("ui_right"):
		return check_doubletap("ui_right")
	
	return ""
		
func check_doubletap(current_action:String):
	var dash_direction = ""
	if last_keycode == current_action and doubletap_time >= 0: 
		dash_direction = str(current_action).replace("ui_", "")
		last_keycode = ""
	doubletap_time = DOUBLETAP_DELAY
	last_keycode = current_action
	
	return dash_direction
		
func walk():
	var direction = Vector3.ZERO  

	if Input.is_action_pressed("ui_up"):
		direction += transform.basis.y
	if Input.is_action_pressed("ui_down"):
		direction -= transform.basis.y
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x

	direction = direction.normalized() * speed  # Normalize to prevent faster diagonal movement and scale by speed

	velocity.x = direction.x
	velocity.y = direction.y
	velocity.z = direction.z

	# Move the character and get the number of collisions
	move_and_slide()

	check_wall_collisions()

func align_with_surface(normal):
	# Align the player with the surface normal
	var up = normal
	var forward = transform.basis.z
	var right = up.cross(forward).normalized()
	forward = right.cross(up).normalized()
	
	 # Create a new basis using the right, up, and forward vectors
	var new_basis = Basis(right, up, forward)
	transform.basis = new_basis

func check_wall_collisions():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() and collision.get_collider().is_in_group(wall_tag):
			var collision_normal = collision.get_normal()
			var wall_direction = determine_wall_direction(collision_normal)
			#print(wall_direction)
			on_wall_collision(collision.get_collider(), wall_direction)

func determine_wall_direction(collision_normal: Vector3) -> String:
	# Transform the collision normal to the player's local space
	var local_collision_normal = transform.basis.inverse() * collision_normal
	
	#print(collision_normal, local_collision_normal)

	if local_collision_normal.y > 0.5:
		return "down"
	elif local_collision_normal.y < -0.5:
		return "up"
	elif local_collision_normal.x > 0.5:
		return "left"
	elif local_collision_normal.x < -0.5:
		return "right"
	elif local_collision_normal.z > 0.5:
		return "top"
	elif local_collision_normal.z < -0.5:
		return "bottom"
	else:
		return "unknown"
		
func on_wall_collision(collider, wall_direction: String):
	var dash_direction = handle_doubletap()
	#print(dash_direction, wall_direction)
	if(dash_direction == wall_direction):
		print(wall_direction)
		#if wall_direction == 'up':
			#target_rotation = Vector3(rotation.x + 1, rotation.y, rotation.z)
		#elif wall_direction == 'down':
			#target_rotation = Vector3(rotation.x - 1, rotation.y, rotation.z)
		#elif wall_direction == 'left':
			#target_rotation = Vector3(rotation.x - 1, rotation.y, rotation.z)
		#elif wall_direction == 'right':
			#target_rotation = Vector3(rotation.x - 1, rotation.y, rotation.z)
		target_direction = wall_direction
		is_rotating = true
		
	
