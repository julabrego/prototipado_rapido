class_name Goal
extends StaticBody2D

@export var closed = true

var is_enemy_inside = false
var is_player_inside = false

signal closed_with_enemy_inside
signal closed_with_player_inside

# Called when the node enters the scene tree for the first time.
func _ready():
	$Arrow.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func open():
	closed = false
	$Door.hide()
	$Door/CollisionPolygon2D2.disabled = true
	$Arrow.show()
	
func close():
	closed = true
	$Door.show()
	$Door/CollisionPolygon2D2.disabled = false
	$Arrow.hide()
	
	if is_enemy_inside:
		closed_with_enemy_inside.emit()
	
	if is_player_inside:
		closed_with_player_inside.emit()

func _on_area_2d_body_entered(body):
	if body.is_in_group('enemy'):
		is_enemy_inside = true
	
	if body.is_in_group('player'):
		is_player_inside = true

func _on_area_2d_body_exited(body):
	if body.is_in_group('enemy'):
		is_enemy_inside = false
	
	if body.is_in_group('player'):
		is_player_inside = false
