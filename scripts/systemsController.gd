extends ColorRect

@export var fallingColor:Color
@export var risingColor:Color
var previousOxygen=0
var update:=0.0
var colorShowing:=false
var oxygenState=0
var waterState=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	checkOxygen()


func checkOxygen():
	var previousOxygen=GameManager.baseOxygen
	var previousWater=GameManager.baseWater
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
		print("rse")
		waterState=1
	else:
		waterState=0
	checkOxygen()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	update+=delta
	if(update>=0.5):
		update=0
		colorShowing=!colorShowing
	oxygen()
	water()
	

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
	previousOxygen=GameManager.baseOxygen
	
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
	previousOxygen=GameManager.baseOxygen
