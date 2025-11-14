extends CanvasLayer

var playerDead=false
var sprintRegen=2
var showing=false
var flashing=false

var oxygenatorFixed=false
var reclaimerFixed=false
var wiresFixed=false
var panelsFixed=false
var doorOpened=false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flash()

func flash():
	await get_tree().create_timer(.7).timeout
	flashing=!flashing
	flash()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(oxygenatorFixed and reclaimerFixed and wiresFixed and panelsFixed and doorOpened==false):
		doorOpened=true
		print("oope")
		GameManager.door.openUp()
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
	for child in $Stats.get_children():
		child.visible=showing
		if(str(child.name)=="Oxygen" and not showing and $Stats/Oxygen/Oxygen.value<=10):
			child.visible=true
	$"Date+Time".visible=showing
	$RichTextLabel.visible=showing
	$ToDo.visible=showing
	if(showing==false and $TextHolder.visible):
		$TextHolder.visible=false
	if(not GameManager.oxygenator.leak>0):
		$ToDo/VBoxContainer/Oxygen.text="[s][color=gray]Fix Oxygenator Pipe"
		oxygenatorFixed=true
	if(GameManager.waterReclaimer.filterClean==true):
		$ToDo/VBoxContainer/Water.text="[s][color=gray]Replace Water Filter"
		reclaimerFixed=true
	if(GameManager.solarField.completed):
		$ToDo/VBoxContainer/Solar.text="[s][color=gray]Reconnect Wires"
		wiresFixed=true
	if(GameManager.solarField.dirty==false):
		$ToDo/VBoxContainer/Solar.text="[s][color=gray]Clean Solar Panels"
		panelsFixed=true
	
func food(_delta):
	if(GameManager.food>100):
		GameManager.food=100
	$Stats/Food/Food.value=GameManager.food
	$Stats/Food/Food.value-=_delta/4.5
	GameManager.food=$Stats/Food/Food.value
	if(GameManager.food<=0):
		GameManager.health-=_delta*4
		
func health(_delta):
	if(GameManager.health>100):
		GameManager.health=100
	$Stats/Health/Health.value=GameManager.health
	if(GameManager.health<=0):
		GameManager.dead="Death"
		get_tree().change_scene_to_file("res://scenes/dead.tscn")
	
func water(_delta):
	_delta*=1.8
	if(GameManager.water>400):
		GameManager.baseHumidity+=GameManager.water-400
		GameManager.water=400
	$Stats/Water/Water.value=GameManager.water
	$Stats/Water/Water.value-=_delta
	GameManager.water=$Stats/Water/Water.value
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
		#if($Stats/Energy/Energy.value>30):
			#GameManager.suitHumidity-=_delta
			#GameManager.water+=_delta
			#$Stats/Water/Water.value=GameManager.water
			#GameManager.playerEnergy-=_delta/4
			#$Stats/Energy/Energy.value=GameManager.playerEnergy
			
	if(GameManager.water<=0):
		GameManager.health-=_delta
	
func stamina(_delta):
	if(sprintRegen<=0):
		$Stats/Stamina/Stamina.value+=_delta*10
	if(Input.is_action_pressed("Sprint") and $Stats/Stamina/Stamina.value>0):
		GameManager.playerSprinting=true
		GameManager.food-=_delta*2
		GameManager.water-=_delta*2.5
		$Stats/Stamina/Stamina.value-=_delta*40
		sprintRegen=2
	else:
		sprintRegen-=_delta
		GameManager.playerSprinting=false
		
func oxygen(_delta):
	$Stats/Oxygen/Oxygen.value=GameManager.oxygen
	if(GameManager.oxygen<10):
		if(flashing):
			$Stats/Oxygen/RichTextLabel.text="[color=red]Oxygen"
		else:
			$Stats/Oxygen/RichTextLabel.text="Oxygen"
	if(GameManager.helmet.visible):
		$Stats/Oxygen/Oxygen.value-=_delta/4
		GameManager.carbon+=_delta/4
		if(GameManager.helmet.visible==false):
			$Stats/Oxygen/Oxygen.value-=_delta/4
			$Stats/Health/Health.value-=_delta*50
		if($Stats/Oxygen/Oxygen.value<=0 and playerDead==false):
			GameManager.health-=_delta*10
	elif(GameManager.playerState==GameManager.possibleStates.INSIDE and GameManager.helmet.visible==false):
		GameManager.baseOxygen-=.4*_delta
		GameManager.baseCarbon+=.4*_delta
	GameManager.oxygen=$Stats/Oxygen/Oxygen.value
		
func energy(_delta):
	if(GameManager.flashlightOn):
		$Stats/Energy/Energy.value-=_delta*2
		if($Stats/Energy/Energy.value<=0):
			GameManager.flashlightOn=false
		GameManager.playerEnergy=$Stats/Energy/Energy.value
		
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
		$Stats/Oxygen/Oxygen.visible=false
		$Stats/Energy/Energy.visible=false
		if(GameManager.basePower>200):
			$Stats/Energy/Energy.value+=_delta
			GameManager.basePower-=_delta
		if(GameManager.baseOxygen>200):
			$Stats/Oxygen/Oxygen.value+=_delta*2
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
