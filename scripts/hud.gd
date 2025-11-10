extends CanvasLayer

var playerDead=false
var sprintRegen=2
var showing=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	stamina(delta)
	food(delta)
	water(delta)
	oxygen(delta)
	energy(delta)
	health(delta)
	inventory()
	dayTime()
	visuals(delta)
	$RichTextLabel.text = "FPS: " + str(Engine.get_frames_per_second())
	if(Input.is_action_just_pressed("HUD")):
		showing=!showing
	$Stats.visible=showing
	$"Date+Time".visible=showing
	$RichTextLabel.visible=showing
	$StatBlocker.visible=showing
	$ToDo.visible=showing
	if(showing==false and $TextHolder.visible):
		$TextHolder.visible=false
	if(not GameManager.oxygenator.leak>0):
		$ToDo/VBoxContainer/Oxygen.text="[s][color=gray]Fix Oxygenator Pipe"
	if(GameManager.waterReclaimer.filterClean==false):
		$ToDo/VBoxContainer/Water.text="Replace Water Filter"
	else:
		$ToDo/VBoxContainer/Water.text="[s][color=gray]Replace Water Filter"
	if(GameManager.solarField.completed):
		$ToDo/VBoxContainer/Solar.text="[s][color=gray]Clean Solar Panels"
	if(GameManager.solarField.dirty==false):
		$ToDo/VBoxContainer/Solar.text="[s][color=gray]Clean Solar Panels"
	else:
		$ToDo/VBoxContainer/Solar.text="Clean Solar Panels"
	
func food(_delta):
	if(GameManager.food>100):
		GameManager.food=100
	$Stats/Food.value=GameManager.food
	$Stats/Food.value-=_delta/4.5
	GameManager.food=$Stats/Food.value
	if(GameManager.food<=0):
		GameManager.health-=_delta*4
		
func health(_delta):
	if(GameManager.health>100):
		GameManager.health=100
	$Stats/Health.value=GameManager.health
	if(GameManager.health<=0):
		GameManager.dead="Death"
		get_tree().change_scene_to_file("res://scenes/dead.tscn")
	
func water(_delta):
	if(GameManager.water>400):
		GameManager.baseHumidity+=GameManager.water-400
		GameManager.water=400
	$Stats/Water.value=GameManager.water
	$Stats/Water.value-=_delta
	GameManager.water=$Stats/Water.value
	if(GameManager.helmet.visible==false):
		GameManager.baseHumidity+=_delta
		if(GameManager.suitHumidity>_delta):
			GameManager.suitHumidity-=_delta
			GameManager.baseHumidity+=_delta
		else:
			GameManager.baseHumidity+=GameManager.suitHumidity
			GameManager.suitHumidity=0
	else:
		GameManager.suitHumidity+=_delta
		if($Stats/Energy.value>30):
			GameManager.suitHumidity-=_delta
			GameManager.water+=_delta
			$Stats/Water.value=GameManager.water
			GameManager.playerEnergy-=_delta/4
			$Stats/Energy.value=GameManager.playerEnergy
			
	if(GameManager.water<=0):
		GameManager.health-=_delta
	
func stamina(_delta):
	if(sprintRegen<=0):
		$Stats/Stamina.value+=_delta*10
	if(Input.is_action_pressed("Sprint") and $Stats/Stamina.value>0 and $Stats/Food.value>25):
		GameManager.playerSprinting=true
		GameManager.food-=_delta*2
		$Stats/Stamina.value-=_delta*40
		sprintRegen=2
	else:
		sprintRegen-=_delta
		GameManager.playerSprinting=false
		
func oxygen(_delta):
	$Stats/Oxygen.value=GameManager.oxygen
	if(GameManager.helmet.visible):
		$Stats/Oxygen.value-=_delta/2
		GameManager.carbon+=_delta/2
		if(GameManager.helmet.visible==false):
			$Stats/Oxygen.value-=_delta*200
			$Stats/Health.value-=_delta*50
		if($Stats/Oxygen.value<=0 and playerDead==false):
			GameManager.health-=_delta*25
	elif(GameManager.playerState==GameManager.possibleStates.INSIDE and GameManager.helmet.visible==false):
		GameManager.baseOxygen-=.4*_delta
		GameManager.baseCarbon+=.4*_delta
	GameManager.oxygen=$Stats/Oxygen.value
		
func energy(_delta):
	if(GameManager.flashlightOn):
		$Stats/Energy.value-=_delta*2
		if($Stats/Energy.value<=0):
			GameManager.flashlightOn=false
		GameManager.playerEnergy=$Stats/Energy.value
		
func inventory():
	if(Input.is_action_just_pressed("1")):
		if(GameManager.selectedSlot!=0):
			GameManager.selectedSlot=0
		else:
			GameManager.selectedSlot=-1
	if(Input.is_action_just_pressed("2")):
		if(GameManager.selectedSlot!=1):
			GameManager.selectedSlot=1
		else:
			GameManager.selectedSlot=-1
	if(Input.is_action_just_pressed("3")):
		if(GameManager.selectedSlot!=2):
			GameManager.selectedSlot=2
		else:
			GameManager.selectedSlot=-1
	if(Input.is_action_just_pressed("4")):
		if(GameManager.selectedSlot!=3):
			GameManager.selectedSlot=3
		else:
			GameManager.selectedSlot=-1
	if(Input.is_action_just_pressed("5")):
		if(GameManager.selectedSlot!=4):
			GameManager.selectedSlot=4
		else:
			GameManager.selectedSlot=-1
	if(GameManager.selectedSlot+1>len(GameManager.inventory)):
		GameManager.selectedSlot=len(GameManager.inventory)-1
		
func dayTime():
	$"Date+Time/Day".text = "Day " + str(GameManager.day)
	var hours = int(floor(GameManager.currentTime))
	var minutes = int(round((GameManager.currentTime - hours) * 60))
	if(minutes>=60):
		minutes=0
		hours+=1
		if(hours>24):
			hours=1
	$"Date+Time/Time".text = str(hours) + ":" + str(minutes).pad_zeros(2)
	
func visuals(_delta):
	if(GameManager.helmet.visible==true):
		for stat in $Stats.get_children():
			stat.visible=true
	else:
		$Stats/Oxygen.visible=false
		$Stats/Energy.visible=false
		if(GameManager.basePower>200):
			$Stats/Energy.value+=_delta
			GameManager.basePower-=_delta
		if(GameManager.baseOxygen>200):
			$Stats/Oxygen.value+=_delta*2
			GameManager.baseOxygen-=_delta*2
		if(GameManager.carbon>0):
			GameManager.carbon-=_delta
			if(GameManager.carbon>=0):
				GameManager.baseCarbon+=_delta
			else:
				GameManager.baseCarbon+=abs(GameManager.carbon)
				GameManager.carbon=0
				
func fade():
	for child in get_children():
		var tween = create_tween()
		tween.tween_property(child, "modulate:a", 0, 1)
		
func reveal():
	for child in get_children():
		var tween = create_tween()
		tween.tween_property(child, "modulate:a", 1, 1)
		
func maxOut():
	for child in $Inventory.get_children():
		child.maxOut()
