extends Control

func update_time(time):
	$ColorRect/HBoxContainer/HBoxContainer2/LabelTime.text = var_to_str(time)
