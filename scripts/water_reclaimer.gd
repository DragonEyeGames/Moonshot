extends ElectronicZoom

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.baseHumidity>200):
		efficiency=.8
		maxPower=1.5
	elif(GameManager.baseHumidity>50):
		efficiency=1.1
		maxPower=.7
	else:
		efficiency=1.2
		maxPower=.15
	efficiency =  1 - ((maxPower/2)-.5)
	efficiency*=4
	maxPower=maxPower/efficiency
	if(overriden):
		maxPower=$ProgressBar.value
		efficiency =  (1 - (($ProgressBar.value/2)-.5))*4
		$ColorRect2.color=Color(1, 0, 0)
		maxPower=maxPower/efficiency
		print(maxPower)
	else:
		$ColorRect2.color=Color(.05, .05, .05)
	$ProgressBar.editable=overriden
	power=maxPower
	powerSap(delta)
	if(GameManager.baseHumidity>power):
		GameManager.baseHumidity-=power
		GameManager.baseWater+=power
	$ColorRect/RichTextLabel.text=str(round(GameManager.baseWater*100)/100)
	$ColorRect4/RichTextLabel.text=str(round(power/delta*100)/100)
	$ColorRect3/RichTextLabel.text=str(round(efficiency*100)/100)
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		zoom()
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		unzoom()


func _on_button_pressed() -> void:
	overriden=!overriden
