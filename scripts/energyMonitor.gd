extends ElectronicZoom

var previousPower=0

func _process(delta: float) -> void:
	$ColorRect/RichTextLabel.text=str(round(GameManager.basePower*100)/100)
	$ColorRect3/RichTextLabel.text=str(round((GameManager.basePower-previousPower)*100)/100)
	$ColorRect4/RichTextLabel.text=str(round(GameManager.solarOutput*100)/100)
	previousPower=GameManager.basePower
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		zoom()
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		unzoom()
