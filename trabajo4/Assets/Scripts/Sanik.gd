extends Sprite

var startX = 136
var finalX = 904
var currentStep = 0
var totalSteps

func _ready():
	pass 
	
func setTotalSteps(_totalSteps):
	totalSteps = _totalSteps

func advance():
	currentStep = currentStep + 1
	position.x = startX + (904 - 136) / totalSteps * currentStep
