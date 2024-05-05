extends Node

var objectInstance
var screenWidth = 0
var spawnTimer = 0
var spawnInterval = 2 
var objectScene = preload("res://Scenes/Figure.tscn")
var spawnTimeList
var spawnedFiguresCounter = 0
var checkPointPositionX
var checkPointPositionY
var rythmDataKeys

var figureDuration = 2.5

func _init(_spawnTimeList, _checkPointPositionX, _checkPointPositionY):
	rythmDataKeys = _spawnTimeList
	
	var rythmDataKeysAsFloats = []
	for key in _spawnTimeList.keys():
		rythmDataKeysAsFloats.append(float(key))
		
	spawnTimeList = rythmDataKeysAsFloats
	checkPointPositionX = _checkPointPositionX
	checkPointPositionY = _checkPointPositionY

func _ready():
	screenWidth = get_viewport().size.x

func _process(delta):
	var target_position = Vector2(checkPointPositionX, checkPointPositionY)

func spawn_object(sound):
	objectInstance = objectScene.instance()
	add_child(objectInstance)
	objectInstance.position.x = screenWidth  
	
	match sound:
		'snare':
			objectInstance.position.y = checkPointPositionY 
			objectInstance.rotation_degrees = 180
		'bassDrum':
			objectInstance.position.y = checkPointPositionY + 25
			
	animate_slide(objectInstance, objectInstance.position.y)

func animate_slide(object, y):
	var slide_duration = figureDuration
	var target_position = Vector2(checkPointPositionX, y) 
	var slide_animation = Tween.new()
	
	add_child(slide_animation)
	
	slide_animation.interpolate_property(object, "position", object.position, target_position, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	slide_animation.connect("tween_completed", self, "_on_animation_finished", [object])
	slide_animation.start()

func _on_animation_finished(tween, object, objectBinds):
	animate_disappear(objectBinds)

func animate_disappear(object):
	var slide_duration = 1 
	var target_position = Vector2(10, checkPointPositionY) 
	var disappear_animation = Tween.new()
	
	add_child(disappear_animation)
	
	disappear_animation.interpolate_property(object, "position", object.position, target_position, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	disappear_animation.interpolate_property(object, "modulate:a", 1.0, 0.0, slide_duration, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	disappear_animation.connect("tween_completed", self, "_on_animation_finished2", [object])
	disappear_animation.start()

func _on_animation_finished2(tween, object, objectBinds):
	objectBinds.queue_free()
	
func spawn_object_if_time_matches(currentTime):
	if spawnedFiguresCounter >= spawnTimeList.size():
		return
		
	var curr = stepify(currentTime, 0.01)
	var toMatch = stepify(spawnTimeList[spawnedFiguresCounter], 0.01) - figureDuration

	if(toMatch - curr < 0.1):
		var origin = spawnTimeList[spawnedFiguresCounter] - 1
		spawn_object(rythmDataKeys[spawnTimeList[spawnedFiguresCounter]])
		spawnedFiguresCounter = spawnedFiguresCounter + 1
