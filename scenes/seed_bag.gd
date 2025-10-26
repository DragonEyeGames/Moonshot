extends ColorRect

var collision=false
var seeds=3
var fading=false

func _process(_delta: float) -> void:
	if(collision and Input.is_action_just_pressed("Click") and seeds>0):
		GameManager.player.pickUp("seeds")
		seeds-=1
	elif(Input.is_action_just_released("Click") and seeds<=0 and not fading):
		fading=true
		await get_tree().create_timer(1).timeout
		seeds=3
		collision=false
		GameManager.interactedItem.unzoom()
		GameManager.playerTool=""
		await get_tree().create_timer(1).timeout
		fading=false

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	if(visible):
		collision=false
