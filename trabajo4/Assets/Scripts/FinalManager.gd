extends Node

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	var scene_tree = get_tree()
	scene_tree.change_scene("res://Scenes/StartHUD.tscn")

