extends Node

export var time = 0
export var timer_on = false

export var rythmData = {
2.142: 'bassDrum',
2.629: 'snare',
3.117: 'bassDrum',
3.326: 'bassDrum',
3.604: 'snare',
4.046: 'bassDrum',
4.533: 'snare',
5.021: 'bassDrum',
5.253: 'bassDrum',
5.508: 'snare',
5.996: 'bassDrum',
6.484: 'snare',
7.018: 'bassDrum',
7.203: 'bassDrum',
7.482: 'snare',
8.016: 'bassDrum',
8.457: 'snare',
8.945: 'bassDrum',
9.200: 'bassDrum',
9.433: 'snare',
9.920: 'bassDrum',
10.408: 'snare',
10.896: 'bassDrum',
11.128: 'bassDrum',
11.383: 'snare',
11.871: 'bassDrum',
12.358: 'snare',
12.823: 'bassDrum',
13.032: 'bassDrum',
13.310: 'snare',
13.798: 'bassDrum',
14.286: 'snare',
14.820: 'bassDrum',
15.029: 'bassDrum',
15.307: 'snare',
17.653: 'bassDrum',
18.187: 'snare',
18.674: 'bassDrum',
18.906: 'bassDrum',
19.185: 'snare',
19.394: 'bassDrum',
19.673: 'bassDrum',
20.160: 'snare',
20.555: 'snare',
20.694: 'bassDrum',
20.903: 'bassDrum',
21.136: 'snare',
21.623: 'bassDrum',
22.111: 'snare',
22.598: 'bassDrum',
22.831: 'bassDrum',
23.086: 'snare',
23.563: 'bassDrum',
24.061: 'snare',
24.433: 'snare',
24.549: 'bassDrum',
24.781: 'snare',
25.013: 'bassDrum',
25.269: 'snare',
25.501: 'bassDrum',
26.035: 'snare',
26.476: 'bassDrum',
26.732: 'bassDrum',
27.010: 'snare',
27.451: 'bassDrum',
27.939: 'snare',
28.334: 'snare',
28.427: 'bassDrum',
28.705: 'bassDrum',
28.914: 'snare',
29.402: 'bassDrum',
29.936: 'snare',
30.377: 'bassDrum',
30.656: 'bassDrum',
30.865: 'snare',
31.376: 'bassDrum',
31.863: 'snare',
32.258: 'snare',
32.397: 'bassDrum',
32.606: 'bassDrum',
32.838: 'snare',
33.047: 'bassDrum',
33.326: 'bassDrum',
33.814: 'snare',
34.301: 'bassDrum',
34.557: 'bassDrum',
34.789: 'snare',
35.276: 'bassDrum',
35.764: 'snare',
36.136: 'snare',
36.205: 'bassDrum',
36.484: 'bassDrum',
36.739: 'snare',
37.227: 'bassDrum',
37.738: 'snare',
38.225: 'bassDrum',
38.481: 'bassDrum',
38.713: 'snare',
39.154: 'bassDrum',
39.642: 'snare',
40.037: 'snare',
40.129: 'bassDrum',
40.362: 'bassDrum',
40.617: 'snare',
40.896: 'bassDrum',
41.105: 'bassDrum',
41.639: 'snare',
42.080: 'bassDrum',
42.312: 'bassDrum',
42.568: 'snare',
43.055: 'bassDrum',
43.566: 'snare',
44.054: 'bassDrum',
44.309: 'bassDrum',
44.541: 'snare',
44.982: 'bassDrum',
45.516: 'snare',
46.004: 'bassDrum',
46.213: 'bassDrum',
46.492: 'snare',
46.979: 'bassDrum',
47.467: 'snare',
47.862: 'snare',
48.047: 'bassDrum',
48.233: 'bassDrum',
48.442: 'snare',
}

var steps = 0

var timerLabelObject 
var finalHUD
var finalHUDInstance

var musicAudioStreamPlayerObject
var checkPoint

var spawnerScript
var spawner

var sanik

var message

var matches = 0
var misses = 0

var finalTime

func _ready():
	timerLabelObject = get_node("../HBoxContainer/TimerLabel")
	musicAudioStreamPlayerObject = get_node("../AudioStreamPlayer2D")
	checkPoint = get_node("../ScoreBackground2/ScoreMatcher/CheckPoint")

	spawnerScript = load("res://Assets/Scripts/FigureSpawner.gd")
	spawner = spawnerScript.new(rythmData, 150, 150)
	add_child(spawner)
	
	message = preload("res://Scenes/Message.tscn")
	
	sanik = get_node("../Sanik")
	sanik.setTotalSteps(rythmData.keys().size())
	
	finalTime = rythmData.keys()[rythmData.keys().size() - 1]
	finalHUD = preload("res://Scenes/FinalHUD.tscn")
	
func _process(delta):
	var currentTime = musicAudioStreamPlayerObject.get_playback_position()
	
	if (timer_on):
		increment(delta)
		
	if Input.is_action_just_pressed("ui_down"):
		#print(var2str(musicAudioStreamPlayerObject.get_playback_position()) + ": 'bassDrum',")
#		print(musicAudioStreamPlayerObject.get_playback_position())
		return match_hit(currentTime, 'bassDrum')
		
	if Input.is_action_just_pressed("ui_up"):
#		print(var2str(musicAudioStreamPlayerObject.get_playback_position()) + ": 'snare',")
		#print(musicAudioStreamPlayerObject.get_playback_position())
		return match_hit(currentTime, 'snare')
		
	spawner.spawn_object_if_time_matches(currentTime)
	
	if(currentTime > finalTime):
		finalHUDInstance = finalHUD.instance()
		finalHUDInstance.get_node("./VBoxContainer/HBoxContainer/MatchesNumber").text = var2str(matches)
		finalHUDInstance.get_node("./VBoxContainer/HBoxContainer2/MissesNumber").text = var2str(misses)
		add_child(finalHUDInstance)

func increment(value) -> void:
	var newTime = time + value
	time = stepify(newTime, 0.001)
	timerLabelObject.text = var2str(time)
	
func _on_Timer_timeout():
	timer_on = true
	musicAudioStreamPlayerObject.play()

func match_hit(currentTime, sound):
	for i in range(currentTime * 1000, currentTime * 1000 - 100, -1):
		var index = float(i) / 1000.0
		
		if rythmData.has(index):
			if(sound == rythmData[index]):
				var messageInstance = message.instance()
				messageInstance.position = Vector2(150, 150)
				messageInstance.get_node("./MessageLabel").text = "¡Bien!"
				add_child(messageInstance)
				sanik.advance()
				matches = matches + 1
			else:
				var messageInstance = message.instance()
				messageInstance.position = Vector2(150, 150)
				messageInstance.get_node("./MessageLabel").text = "Mal..."
				add_child(messageInstance)
				misses = misses + 1
			return
			
	for i in range(currentTime * 1000, currentTime * 1000 + 100):
		var index = float(i) / 1000.0
	
		if rythmData.has(index):
			if(sound == rythmData[index]):
				var messageInstance = message.instance()
				messageInstance.position = Vector2(150, 150)
				messageInstance.get_node("./MessageLabel").text = "¡Bien!"
				add_child(messageInstance)
				sanik.advance()
				matches = matches + 1
			else:
				var messageInstance = message.instance()
				messageInstance.position = Vector2(150, 150)
				messageInstance.get_node("./MessageLabel").text = "Mal..."
				add_child(messageInstance)
				misses = misses + 1
			return
