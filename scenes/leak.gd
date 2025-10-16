extends Node2D

var colliding=false
var zoomed=false
var canZoom=true


func _process(delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(zoomed==false and canZoom):
			zoom()
		elif(zoomed and canZoom):
			unzoom()
		

func _on_area_2d_body_entered(body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
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
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
