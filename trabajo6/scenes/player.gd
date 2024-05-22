class_name Player
extends CharacterBody3D

@export var speed : float = 5.0  # Speed of the character
@export var wall_tag : String = "Terrain"  # Tag to identify wall objects

const DOUBLETAP_DELAY = .25
var doubletap_time = DOUBLETAP_DELAY
var last_keycode:String = ""
var is_rotating:bool = false
var target_rotation

func _ready():
	target_rotation = rotation

func _physics_process(delta):
	doubletap_time -= delta
	walk()
	
	if is_rotating:
		if rotation.x > target_rotation.x:
			rotation.x -= 0.02
		elif rotation.x < target_rotation.x:
			rotation.x += 0.02
			
		if rotation.y > target_rotation.y:
			rotation.y -= 0.02
		elif rotation.y < target_rotation.y:
			rotation.y += 0.02
			
		if rotation.z > target_rotation.z:
			rotation.z -= 0.02
		elif rotation.z < target_rotation.z:
			rotation.z += 0.02
		
		if abs(rotation.x) - abs(target_rotation.x) < 0.02 and abs(rotation.y) - abs(target_rotation.y) < 0.02 and abs(rotation.z) - abs(target_rotation.z) < 0.02:
			rotation = target_rotation
			is_rotating = false

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
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() and collision.get_collider().is_in_group(wall_tag):
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
	var dash_direction = handle_doubletap()
	if(dash_direction == wall_direction):
		target_rotation = collider.get_rotation()
		is_rotating = true
	
