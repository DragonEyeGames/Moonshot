extends ElectronicZoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.editable=overriden
	if(GameManager.baseCarbon>500):
		efficiency=.7
		maxPower=10
	elif(GameManager.baseCarbon>400):
		efficiency=.85
		maxPower=5
	elif(GameManager.baseCarbon>300):
		efficiency=1.1
		maxPower=1.1
	elif(GameManager.baseCarbon>200):
		efficiency=1.3
		maxPower=.2
	elif(GameManager.baseCarbon>100):
		maxPower=.1
	else:
		maxPower=0
	efficiency =  1 - ((maxPower/10)-.5)
	maxPower=maxPower/efficiency
	efficiency*=2
	if(overriden):
		maxPower=$ProgressBar.value
		efficiency =  (1 - (($ProgressBar.value/10)-.5))*2
		$ColorRect2.color=Color(1, 0, 0)
		maxPower=maxPower/efficiency
	else:
		$ColorRect2.color=Color(.05, .05, .05)
	power=maxPower
	powerSap(delta)
	if(power<=GameManager.baseCarbon):
		GameManager.baseOxygen+=power
		GameManager.baseCarbon-=power
	else:
		GameManager.baseOxygen+=GameManager.baseCarbon
		GameManager.baseCarbon=0
	$ColorRect4/RichTextLabel.text=str(round(power/efficiency/delta*100)/100)
	$ColorRect/RichTextLabel.text=str(round(GameManager.baseOxygen*10)/10)
	$ColorRect4/RichTextLabel.text=str(round(power/efficiency/delta*100)/100)
	$ColorRect3/RichTextLabel.text=str(round(efficiency*50)/100)
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		zoom()
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		unzoom()

func _on_button_pressed() -> void:
	overriden=!overriden
