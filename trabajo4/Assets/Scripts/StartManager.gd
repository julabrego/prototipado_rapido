extends Node

var btnEscuchar
var btnJugar
var audioStreamPlayer
var new_scene

func _ready():
	audioStreamPlayer = get_node("../AudioStreamPlayer")
	btnEscuchar = get_node("../VBoxContainer/HBoxContainer/ButtonEscuchar")
	btnJugar = get_node("../VBoxContainer/HBoxContainer5/ButtonJugar")

func _on_ButtonEscuchar_pressed():
	if !audioStreamPlayer.playing:
		audioStreamPlayer.playing = true
		btnEscuchar.text = "Pausar canción"
	else:
		audioStreamPlayer.playing = false
		btnEscuchar.text = "Escuchar canción"


func _on_ButtonJugar_pressed():
	var scene_tree = get_tree()
	scene_tree.change_scene("res://Scenes/Level2.tscn")
