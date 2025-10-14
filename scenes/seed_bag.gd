extends ColorRect

var collision=false
var seeds=3
var fading=false

func _process(delta: float) -> void:
	if(collision and Input.is_action_just_pressed("Click") and seeds>0):
		GameManager.player.pickUp("seeds")
		seeds-=1
	elif(Input.is_action_just_released("Click") and seeds<=0 and not fading):
		fading=true
		await get_tree().create_timer(1).timeout
		GameManager.interactedItem.unzoom()
		GameManager.playerTool=""

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(visible):
		collision=false
