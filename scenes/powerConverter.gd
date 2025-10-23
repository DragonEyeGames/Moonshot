extends Node2D

var colliding=true
var zoomed=false
var canZoom=true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact") and canZoom and not zoomed):
		await zoom()
		$"Motion Controller".play("open")
	elif(colliding and Input.is_action_just_pressed("Interact") and canZoom and zoomed):
		await unzoom()
		$"Motion Controller".play("close")


func _on_area_2d_body_entered(body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding=false

func zoom():
	GameManager.zoomCamera($ZoomPoint, 5.5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.playerTool=""
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


func _red_entered() -> void:
	pass # Replace with function body.


func _red_exited() -> void:
	pass # Replace with function body.
