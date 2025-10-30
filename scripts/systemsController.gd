extends ColorRect

@export var fallingColor:Color
@export var risingColor:Color
var update:=0.0
var colorShowing:=false
var oxygenState=0
var waterState=0
var powerState=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkStats()


func checkStats():
	var previousOxygen=GameManager.baseOxygen
	var previousWater=GameManager.baseWater
	var previousEnergy=GameManager.basePower
	await get_tree().create_timer(.5).timeout
	if(GameManager.baseOxygen-previousOxygen<-1):
		oxygenState=-1
	elif(GameManager.baseOxygen-previousOxygen>1):
		oxygenState=1
	else:
		oxygenState=0
		
	if(GameManager.baseWater-previousWater<-.001):
		waterState=-1
	elif(GameManager.baseWater-previousWater>.001):
		waterState=1
	else:
		waterState=0
		
	if(GameManager.basePower-previousEnergy<-.05):
		powerState=-1
	elif(GameManager.basePower-previousEnergy>.05):
		powerState=1
	else:
		powerState=0
	checkStats()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update+=delta
	if(update>=0.5):
		update=0
		colorShowing=!colorShowing
	oxygen()
	water()
	energy()
	oxygenator()
	waterReclaimer()
	powerGrid()
	

func oxygen():
	var rising=risingColor.to_html(true)
	var falling=fallingColor.to_html(true)
	var oxygenSuffix:="[color=white]Stable"
	if(oxygenState==-1):
		var showingColor=""
		if(colorShowing):
			showingColor = "[color=" + str(falling) + "]"
		oxygenSuffix=showingColor + "Falling"
	elif(oxygenState==1):
		var showingColor="[color=" + str(rising)
		oxygenSuffix=showingColor + "]Rising"
	$Oxygen.text="Oxygen . . . . . . . . . "+ oxygenSuffix+ " " + str(round((GameManager.baseOxygen/(GameManager.baseOxygen+GameManager.baseCarbon))*10000)/100)+"%"
	
func water():
	var rising=risingColor.to_html(true)
	var falling=fallingColor.to_html(true)
	var suffix:="[color=white]Stable"
	if(waterState==-1):
		var showingColor=""
		if(colorShowing):
			showingColor = "[color=" + str(falling) + "]"
		suffix=showingColor + "Falling"
	elif(waterState==1):
		var showingColor="[color=" + str(rising)
		suffix=showingColor + "]Rising"
	$Water.text="Water . . . . . . . . . . "+ suffix+ " " + str(round(GameManager.baseWater*100)/400)+"Ml"
	
func energy():
	var rising=risingColor.to_html(true)
	var falling=fallingColor.to_html(true)
	var suffix:="[color=white]Stable"
	if(powerState==-1):
		var showingColor=""
		if(colorShowing):
			showingColor = "[color=" + str(falling) + "]"
		suffix=showingColor + "Falling"
	elif(powerState==1):
		var showingColor="[color=" + str(rising)
		suffix=showingColor + "]Rising"
	$Power.text="Power . . . . . . . . . . "+ suffix+ " " + str(round(GameManager.basePower*10)/10)+"KwH"

func oxygenator():
	var prefix="Nominal"
	var falling=fallingColor.to_html(true)
	if(GameManager.oxygenator.leak>0):
		prefix=""
		if(colorShowing):
			prefix+="[color=" + falling +"]"
		prefix+="Leaking"
	$Oxygenator.text="Oxygenator . . . . . " + prefix
	
func waterReclaimer():
	var prefix:=""
	var falling=fallingColor.to_html(true)
	if(GameManager.waterReclaimer.filterClean==false):
		prefix="Replace Filter"
		if(colorShowing):
			prefix="[color=" + falling +"]" + prefix
	else:
		prefix="Stable"
	
	$WaterReclaimer.text="Water Reclaimer . " + str(prefix)

func powerGrid():
	$"Solar Array".text="Solar Array . . . . . . " + str(GameManager.currentEmission*10) +" kWh"
