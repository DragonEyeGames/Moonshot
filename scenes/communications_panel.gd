extends Node2D

var alignEntered:=false

var zoomed:=false
var canZoom:=true
var entered:=false
var extraZoomed:=false
var canExtraZoom:=false
var maxBattery:=100.0
var batteryPower:=0.0
var power:=5.0
var nerf:=1.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.satellite=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Power/Battery/ProgressBar.value=(batteryPower/maxBattery)*100
	$Power/Power/Value.text=str(power*nerf) + "KWH"
	if(batteryPower>100):
		GameManager.basePower+=batteryPower-100
		batteryPower=maxBattery
	if(GameManager.basePower>power*nerf*delta and batteryPower<maxBattery):
		batteryPower+=power*nerf*delta
		GameManager.basePower-=power*nerf*delta
		if(batteryPower>maxBattery):
			GameManager.basePower+=batteryPower-100
			power=0.0
			batteryPower=maxBattery
	elif(GameManager.basePower<=power*nerf*delta and batteryPower<maxBattery):
		batteryPower+=GameManager.basePower
		GameManager.basePower=0
	if(alignEntered and Input.is_action_just_pressed("Click")):
		if(not extraZoomed and canExtraZoom):
			extraZoom($Align/ZoomPoint)
	elif(alignEntered and Input.is_action_just_pressed("Interact") and extraZoomed and canExtraZoom):
		extraUnzoom()
	if(entered and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom):
			zoom()
			canExtraZoom=true
		elif(zoomed and canZoom):
			unzoom()
			canExtraZoom=false
	$Align/Degrees/RichTextLabel.text=str(float(round($Align/Interface/SatelliteDish.rotation_degrees*10))/10) + "°"
	if($Align/Interface/SatelliteDish.rotation_degrees<=40):
		$Align/Strength/RichTextLabel2.text=str(int(round(100*get_percent($Align/Interface/SatelliteDish.rotation_degrees, 15, 40)))) + "%"
	elif($Align/Interface/SatelliteDish.rotation_degrees>40):
		$Align/Strength/RichTextLabel2.text=str(int(round(100*get_percent(80-($Align/Interface/SatelliteDish.rotation_degrees), 15, 40)))) + "%"
	if(batteryPower>=100 and round($Align/Interface/SatelliteDish.rotation_degrees)==40):
		$Able/ColorRect.color=Color.LIME_GREEN
		$Button.disabled=true
	else:
		$Able/ColorRect.color = Color.ORANGE_RED
		$Button.disabled=false

func get_percent(value: float, minVal: float, maxVal: float):
	return clamp((value - minVal) / (maxVal - minVal), 0.0, 1.0)

func zoom(type="fadeToArm"):
	GameManager.zoomCamera($ZoomPoint, 4)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom(type="appear"):
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
	
func extraZoom(target):
	GameManager.zoomCamera(target, 10)
	extraZoomed=true
	canExtraZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	#GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	canExtraZoom=true

func extraUnzoom(type="fade"):
	GameManager.zoomCamera($ZoomPoint, 4)
	extraZoomed=false
	canExtraZoom=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	canExtraZoom=true
	
func _align_entered() -> void:
	alignEntered=true


func _align_exited() -> void:
	alignEntered=false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	entered=true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	entered=false


func satelliteLeft() -> void:
	if(extraZoomed):
		$Align/Interface/SatelliteDish.rotation_degrees-=2.5


func satelliteRight() -> void:
	if(extraZoomed):
		$Align/Interface/SatelliteDish.rotation_degrees+=2.5


func _on_button_pressed() -> void:
	print("GameOver!!!")
