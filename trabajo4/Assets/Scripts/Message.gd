extends Node

var message 
# Called when the node enters the scene tree for the first time.
func _ready():
	animate_disappear(self)

func animate_disappear(object):
	var slide_duration = 1  
	var disappear_animation = Tween.new()
	add_child(disappear_animation)
	
	# Interpolate alpha
	 # Interpolate alpha
	disappear_animation.interpolate_property(object, "modulate:a", 1.0, 0.0, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	# Interpolate scale
	disappear_animation.interpolate_property(object, "scale", Vector2(1.0, 1.0), Vector2(0.0, 0.0), slide_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	# Interpolate rotation
	disappear_animation.interpolate_property(object, "rotation_degrees", 0.0, 360.0, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	
	disappear_animation.connect("tween_completed", self, "_on_animation_finished")
	disappear_animation.start()

func _on_animation_finished(object):
	self.queue_free()
