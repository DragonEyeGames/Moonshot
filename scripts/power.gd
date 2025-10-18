extends Node

var powerEmission:=0.0
var dirt:=0.0
var colliding:=false
var zoomed=false
var canZoom=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	powerEmission=GameManager.sunPower*6
	powerEmission-=dirt*powerEmission
	GameManager.basePower+=powerEmission*delta
	if(randi_range(0, 500)==5):
		var random=randf_range(1, 2)
		dirt+=delta*random
		for number in range(round(random)):
			var speckle=$Speckle.duplicate()
			speckle.visible=true
			self.add_child(speckle)
			speckle.position=Vector2(
				randi_range(255, 50),
				randi_range(535, 20)
			)
	GameManager.solarOutput=powerEmission
	
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and not zoomed and canZoom):
		GameManager.zoomCamera($ZoomPoint, 3)
		zoomed=true
		canZoom=false
		GameManager.playerMove=false
		GameManager.playerAnimator.play("fadeToArm")
		GameManager.playerTool="rag"
		await get_tree().create_timer(1.1).timeout
		canZoom=true
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and zoomed and canZoom):
		GameManager.unzoomCamera()
		zoomed=false
		GameManager.playerAnimator.play("revealToArm")
		await get_tree().create_timer(1.1).timeout
		GameManager.playerTool=""
		GameManager.playerMove=true
		canZoom=true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false
