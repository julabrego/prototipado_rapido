extends Node

var btnJugar
var new_scene

func _ready():
	btnJugar = get_node("../VBoxContainer/HBoxContainer5/ButtonJugar")

func update_time(time):
	$Control/VBoxContainer/VBoxContainer2/TimeLabel.text = var_to_str(time) + " segundos"
	
func _on_ButtonJugar_pressed():
	var scene_tree = get_tree()
	scene_tree.change_scene_to_file("res://scenes/sombra.tscn")
