extends Node2D

var alignEntered:=false

var zoomed=false
var canZoom=true
var entered=false
var extraZoomed=false
var canExtraZoom=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
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

func get_percent(value: float, min: float, max: float) -> float:
	return clamp((value - min) / (max - min), 0.0, 1.0)

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
