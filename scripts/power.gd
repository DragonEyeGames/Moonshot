extends Node

var powerEmission:=0.0
var dirt:=0.0
var colliding:=false
var zoomed=false
var canZoom=true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in range(120):
		var random=randf_range(1, 2)
		for number in range(round(random)):
			var speckle=$Speckle.duplicate()
			speckle.visible=true
			$Speckles.add_child(speckle)
			speckle.position=Vector2(
				randi_range(-651, 694),
				randi_range(-320, 342)
			)
			speckle.rotation=randi_range(-180, 180)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dirt=len($Speckles.get_children())*delta
	powerEmission=GameManager.sunPower*2
	powerEmission-=dirt
	if(randi_range(0, 1000)==5):
		var random=randf_range(1, 2)
		for number in range(round(random)):
			var speckle=$Speckle.duplicate()
			speckle.visible=true
			$Speckles.add_child(speckle)
			speckle.position=Vector2(
				randi_range(-651, 694),
				randi_range(-320, 342)
			)
			speckle.rotation=randi_range(-180, 180)
	#GameManager.solarOutput=powerEmission
	
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]["name"]=="Rag" and not zoomed and canZoom):
		GameManager.zoomCamera($ZoomPoint, 3)
		zoomed=true
		canZoom=false
		GameManager.playerMove=false
		GameManager.playerAnimator.play("fadeToArm")
		GameManager.playerTool="rag"
		await get_tree().create_timer(1.1).timeout
		canZoom=true
	elif(colliding and Input.is_action_just_pressed("Interact") and zoomed and canZoom):
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
