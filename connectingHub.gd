extends Building


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.basePower>100):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	elif(GameManager.basePower>50):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)*.75
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	elif(GameManager.basePower>20):
		$PointLight2D2.energy=(1.0-GameManager.sunPower)*.4
		GameManager.basePower-=($PointLight2D2.energy/4)*delta
	else:
		$PointLight2D2.energy=0
	if(GameManager.playerState=="inside" and GameManager.helmet.visible==false):
		GameManager.baseOxygen-=.4*delta
	$RichTextLabel2.text=str(round(GameManager.baseOxygen*10)/10)
	$RichTextLabel3.text=str(round(GameManager.basePower*1000)/1000)
	electronicPrioritizing()
	
func electronicPrioritizing():
	$"Water Reclaimer".priorityNerf=1
	$Oxygenator.priorityNerf=1
	if(GameManager.basePower<=10):
		$"Water Reclaimer".priorityNerf=0
		$Oxygenator.priorityNerf=.1
		if(not $PointLight2D2/AnimationPlayer.is_playing()):
			$PointLight2D2/AnimationPlayer.play("danger")
	elif(GameManager.basePower<=20):
		$"Water Reclaimer".priorityNerf=0
		if(GameManager.baseOxygen>30):
			$Oxygenator.priorityNerf=.5
		else:
			$Oxygenator.priorityNerf=.8
		if(not $PointLight2D2/AnimationPlayer.is_playing()):
			$PointLight2D2/AnimationPlayer.play("danger")
	elif(GameManager.basePower<=50):
		$"Water Reclaimer".priorityNerf=.2
		if(GameManager.baseOxygen>50):
			$Oxygenator.priorityNerf=.7
		if(not $PointLight2D2/AnimationPlayer.is_playing()):
			$PointLight2D2/AnimationPlayer.play("danger")
	elif(GameManager.basePower<=100):
		$"Water Reclaimer".priorityNerf=.5
		if(GameManager.baseOxygen>50):
			$Oxygenator.priorityNerf=.9
		if $PointLight2D2/AnimationPlayer.is_playing():
			$PointLight2D2/AnimationPlayer.play("RESET")
