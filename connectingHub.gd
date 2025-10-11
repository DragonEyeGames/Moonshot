extends Building


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.basePower>20):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	elif(GameManager.basePower>10):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)*.75
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	elif(GameManager.basePower>5):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)*.4
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	else:
		$PointLight2D2.energy=0
	if(GameManager.playerState=="inside" and GameManager.helmet.visible==false):
		GameManager.baseOxygen-=.4*delta
	$RichTextLabel2.text=str(round(GameManager.baseOxygen*10)/10)
	$RichTextLabel3.text=str(round(GameManager.basePower*10)/10)
