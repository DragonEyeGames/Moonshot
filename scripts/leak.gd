extends Node2D

var colliding=false
var zoomed=false
var canZoom=true
var coverings=0

func _ready() -> void:
	rotation_degrees=randi_range(0, 360)
	$"../../Oxygenator".leak+=1

func _process(_delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(zoomed==false and canZoom and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]["name"]=="Tape"):
			zoom()
		elif(zoomed and canZoom):
			unzoom()
	if(coverings>0 and $airflow.emitting):
		$airflow.emitting=false
		$"../../Oxygenator".leak-=1
	elif(coverings<=0 and not $airflow.emitting):
		$airflow.emitting=true
		$"../../Oxygenator".leak+=1
		

func _on_area_2d_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false

func zoom():
	GameManager.zoomCamera($ZoomPoint, 9)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.playerTool="tape"
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerAnimator.play("revealToArm")
	GameManager.playerTool=""
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
