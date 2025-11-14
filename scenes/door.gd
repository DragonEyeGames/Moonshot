extends Node2D

var playerEntered:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.door=self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		$Text.visible=!$Text.visible
		GameManager.playerMove=!$Text.visible

func zoom(type="fade"):
	GameManager.zoomCamera($ZoomPoint, 1.5)
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout

func unzoom(type="appear"):
	GameManager.unzoomCamera()
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	
func openUp():
	var roofVisible=get_parent().get_node("HallwayOutside").visible
	if(roofVisible):
		get_parent().get_node("HallwayOutside").visible=false
	zoom()
	await get_tree().create_timer(1.4).timeout
	$Door.play("open")
	await get_tree().create_timer(3).timeout
	unzoom()
	await get_tree().create_timer(.2).timeout
	if(roofVisible):
		get_parent().get_node("HallwayOutside").visible=true

func _on_area_2d_body_entered(_body: Node2D) -> void:
	playerEntered=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	playerEntered=false
