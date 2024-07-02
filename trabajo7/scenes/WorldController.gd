extends Node2D

@export var goals: Array[Node2D]

var is_playing = false
var is_countdown_running = false

func _ready():
	$CanvasLayer/MAIN_MENU.show()
	$CanvasLayer/HUD.hide()
	$CanvasLayer/HUD_FINAL.hide()
	$Player.can_move = false
	$Enemy.can_move = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_countdown_running:
		$CanvasLayer/HUD/VBoxContainer/CountdownLabel.text = var_to_str(int(ceil($CountdownTimer.time_left))) + "..."
	
	if is_playing:
		$CanvasLayer/HUD/VBoxContainer/Count.text = var_to_str(int(ceil($Timer.time_left)))
	
func start_game():
	$CanvasLayer/MAIN_MENU.hide()
	$CanvasLayer/HUD.show()
	$CountdownTimer.start()
	is_countdown_running = true

func _on_enemy_got_in_camera():
	$Player.hide_arrow()

func _on_enemy_got_out_of_camera():
	$Player.show_arrow()

func _on_enemy_enemy_got_dizzy():
	for goal in goals:
		goal.open()

func _on_enemy_enemy_is_no_more_dizzy():
	for goal in goals:
		goal.close()

func _on_goal_closed_with_enemy_inside():
	is_playing = false
	$CanvasLayer/HUD_FINAL/VBoxContainer/Label.text = "¡Ganaste!"
	$CanvasLayer/HUD_FINAL.show()
	$Timer.stop()

func _on_goal_closed_with_player_inside():
	is_playing = false
	$CanvasLayer/HUD_FINAL/VBoxContainer/Label.text = "Perdiste..."
	$CanvasLayer/HUD_FINAL.show()
	$Timer.stop()

func _on_button_pressed():
	start_game()

func _on_countdown_timer_timeout():
	is_playing = true
	
	$Player.can_move = true
	$Enemy.can_move = true
	$CanvasLayer/HUD/VBoxContainer/CountdownLabel.hide()
	$CanvasLayer/HUD/VBoxContainer/Count.show()
	$Timer.start()

func _on_restart_button_pressed():
	get_tree().reload_current_scene()

func _on_timer_timeout():
	is_playing = false
	$Player.can_move = false
	$Enemy.can_move = false
	$CanvasLayer/HUD_FINAL/VBoxContainer/Label.text = "Perdiste..."
	$CanvasLayer/HUD_FINAL.show()
	$CanvasLayer/HUD/VBoxContainer/Count.hide()
	
