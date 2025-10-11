extends Electronic


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.baseOxygen<5):
		efficiency=.7
		maxPower=10
	elif(GameManager.baseOxygen<40):
		efficiency=.8
		maxPower=5
	elif(GameManager.baseOxygen<60):
		efficiency=1.1
		maxPower=1.1
	elif(GameManager.baseOxygen<90):
		efficiency=1.3
		maxPower=.1
	power=maxPower
	powerSap(delta)
	GameManager.baseOxygen+=power
	if(GameManager.baseOxygen>100):
		GameManager.baseOxygen=100
