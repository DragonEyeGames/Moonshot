extends Node2D

var displayedPower:=0.0
var entered=false
var canZoom=true
var zoomed=false
var oxygenatorConsumption:=0.0
var finalOxygenator:=0.0
var timer:=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateEnergy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	countChanges(delta)
	$Panel/ReservedAmount.text=str((round(GameManager.basePower*10)/10)) + "KWH"
	$"Panel/Input Amount".text=str((round(GameManager.currentEmission*10)/10)) + "KWH"
	$"Panel/Used Amount".text=str((round((displayedPower)*10)/10)) + "KWH"
	if(entered and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom):
			canZoom=false
			zoom()
		elif(zoomed and canZoom):
			canZoom=false
			unzoom()
	GameManager.oxygenator.priorityNerf = $Panel/OxygenSlider.value/100
	$"Panel/Oxygenator Count".text=str(round(finalOxygenator*10)/10) + "KWH"
	
	
func zoom():
	$Cover.visible=false
	GameManager.zoomCamera($ZoomPoint,7)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.player.handHeldItem=""
	GameManager.playerTool=""
	GameManager.collisionTool=self
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	$Cover.visible=true
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerMove=true
	GameManager.playerTool=""
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	canZoom=true
	
func updateEnergy():
	var previousPower=GameManager.basePower
	await get_tree().create_timer(1).timeout
	displayedPower=-1*(GameManager.basePower-previousPower)
	updateEnergy()
	
func countChanges(delta: float):
	timer+=delta
	oxygenatorConsumption+=GameManager.oxygenator.consumption
	print(GameManager.oxygenator.consumption)
	if(timer>=1):
		timer-=1
		finalOxygenator=oxygenatorConsumption
		oxygenatorConsumption=0.0


func _on_area_2d_body_entered(_body: Node2D) -> void:
	entered=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	entered=false
