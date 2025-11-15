extends ElectronicZoom

var previousPower=0
@export var minimum: int = 1
@export var maximum: int = 4

func _process(_delta: float) -> void:
	if(GameManager.player.global_position.y>self.global_position.y):
		z_index=minimum
	else:
		z_index=maximum
	$ColorRect/RichTextLabel.text=str(round(GameManager.basePower*100)/100)
	$ColorRect3/RichTextLabel.text=str(round((GameManager.basePower-previousPower)*100)/100)
	$ColorRect4/RichTextLabel.text=str(GameManager.currentEmission)
	previousPower=GameManager.basePower
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		zoom()
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		unzoom()
