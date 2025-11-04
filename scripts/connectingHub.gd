extends Building


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
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
