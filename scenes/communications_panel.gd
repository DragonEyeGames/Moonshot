extends Node2D

var alignEntered:=false

var zoomed:=false
var canZoom:=true
var entered:=false
var extraZoomed:=false
var canExtraZoom:=false
var maxBattery:=100.0
var batteryPower:=100.0
var power:=5.0
var nerf:=1.0
@export var noise:=50.0
var knobEntered=false
var rotatingKnob=false
var rotationDegrees:=-1000
var noiseEntered=false
var zoomedInto:=""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.satellite=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(extraZoomed and zoomedInto=="noise"):
		$Warble.volume_db=lerp(10, -40, noise/100/.22)
		$Static.volume_db=lerp(-40, 0, noise/100/.22)
	else:
		$Warble.volume_db=-80
		$Static.volume_db=-80
	$Noise/Strength/RichTextLabel2.text=str(round(get_percent(-abs(rotationDegrees), -1500, 0)*1000)/10) + "%"
	noise=abs(100-round(get_percent(-abs(rotationDegrees), -1500, 0)*1000)/10)*.22
	$Noise/Control/Noise.self_modulate.a=noise/30
	if(knobEntered and Input.is_action_just_pressed("Click") and extraZoomed):
		rotatingKnob=true
	elif(knobEntered and Input.is_action_just_pressed("Click")):
		if(not extraZoomed and canExtraZoom):
			zoomedInto="noise"
			extraZoom($Noise/ZoomPoint)
	if(rotatingKnob):
		var diff=$Noise/Knob.rotation_degrees
		$Noise/Knob.look_at(get_global_mouse_position())
		$Noise/Knob.rotation+=PI/2
		diff-=$Noise/Knob.rotation_degrees
		if(Input.is_action_just_released("Click")):
			rotatingKnob=false
		if diff > 180:
			diff -= 360
		elif diff < -180:
			diff += 360
		rotationDegrees-=diff
	$Noise/Control/Noise.texture.noise.seed+=1
	$Power/Battery/ProgressBar.value=(batteryPower/maxBattery)*100
	$Power/Power/Value.text=str(power*nerf) + "KWH"
	var points = $Noise/Control/Line2D.points
	for i in range(points.size()):
		points[i].y = randf_range(-noise, noise)
	points[0].y=0
	points[-1].y=0
	$Noise/Control/Line2D.points = points
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
	if(entered and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom):
			zoom()
			canExtraZoom=true
		elif(zoomed and canZoom and not extraZoomed):
			unzoom()
			canExtraZoom=false
	if(alignEntered and Input.is_action_just_pressed("Click")):
		if(not extraZoomed and canExtraZoom):
			extraZoom($Align/ZoomPoint)
			zoomedInto="align"
	elif(Input.is_action_just_pressed("Interact") and extraZoomed and canExtraZoom):
		extraUnzoom()
		zoomedInto=""
	if(noiseEntered and Input.is_action_just_pressed("Click")):
		if(not extraZoomed and canExtraZoom):
			extraZoom($Noise/ZoomPoint)
			zoomedInto="noise"
	elif(Input.is_action_just_pressed("Interact") and extraZoomed and canExtraZoom):
		extraUnzoom()
		zoomedInto=""
	$Align/Degrees/RichTextLabel.text=str(float(round($Align/Interface/SatelliteDish.rotation_degrees*10))/10) + "°"
	if($Align/Interface/SatelliteDish.rotation_degrees<=40):
		$Align/Strength/RichTextLabel2.text=str(int(round(100*get_percent($Align/Interface/SatelliteDish.rotation_degrees, 15, 40)))) + "%"
	elif($Align/Interface/SatelliteDish.rotation_degrees>40):
		$Align/Strength/RichTextLabel2.text=str(int(round(100*get_percent(80-($Align/Interface/SatelliteDish.rotation_degrees), 15, 40)))) + "%"
	if(batteryPower>=100 and round($Align/Interface/SatelliteDish.rotation_degrees)==40 and noise==0):
		$Able/ColorRect.color=Color.LIME_GREEN
		$Button.disabled=false
	else:
		$Able/ColorRect.color = Color.ORANGE_RED
		$Button.disabled=true

func get_percent(value: float, minVal: float, maxVal: float):
	return clamp((value - minVal) / (maxVal - minVal), 0.0, 1.0)

func zoom(type="fadeToArm"):
	GameManager.zoomCamera($ZoomPoint, 3.8)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom(type="revealToArm"):
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

func extraUnzoom(_type="fade"):
	GameManager.zoomCamera($ZoomPoint, 4)
	extraZoomed=false
	canExtraZoom=false
	#GameManager.playerAnimator.play(type)
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
	else:
		if(not extraZoomed and canExtraZoom):
			zoomedInto="align"
			extraZoom($Align/ZoomPoint)


func satelliteRight() -> void:
	if(extraZoomed):
		$Align/Interface/SatelliteDish.rotation_degrees+=2.5
	else:
		if(not extraZoomed and canExtraZoom):
			zoomedInto="align"
			extraZoom($Align/ZoomPoint)


func _on_button_pressed() -> void:
	print("GameOver!!!")


func _knob_entered() -> void:
	knobEntered=true


func _knob_exited() -> void:
	knobEntered=false


func _on_noise_mouse_entered() -> void:
	noiseEntered=true


func _on_noise_mouse_exited() -> void:
	noiseEntered=false
