extends Electronic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.baseHumidity>50):
		efficiency=.8
		maxPower=1.5
	elif(GameManager.baseHumidity>20):
		efficiency=1.1
		maxPower=.7
	else:
		efficiency=1.2
		maxPower=.15
	efficiency*=4
	power=maxPower
	powerSap(delta)
	if(GameManager.baseHumidity>power):
		GameManager.baseHumidity-=power
		GameManager.baseWater+=power
	$"../RichTextLabel5".text=str(GameManager.baseHumidity)
	$"../RichTextLabel6".text=str(GameManager.baseWater)
