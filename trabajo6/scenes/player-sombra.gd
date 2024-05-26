extends CharacterBody3D

@export var speed : float = 5.0  # Speed of the character
@export var wall_tag : String = "Terrain"  # Tag to identify wall objects

func _physics_process(delta):
	if $"../Controller".playing:
		walk()

func walk():
	var direction = Vector3.ZERO
	if Input.is_action_pressed("ui_up"):
		direction.y += 1
	if Input.is_action_pressed("ui_down"):
		direction.y -= 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1

	direction = direction.normalized() * speed

	velocity.x = direction.x
	velocity.y = direction.y

	move_and_slide()
