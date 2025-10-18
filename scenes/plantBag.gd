extends ColorRect

var collision=false

var fading=false

func _process(_delta: float) -> void:
	if(Input.is_action_just_released("Click") and collision and GameManager.player.currentlyHeld!=null):
		GameManager.player.currentlyHeld.queue_free()
		GameManager.player.handHeldItem=""
		GameManager.carrots+=1
	if(Input.is_action_just_pressed("Interact") and not fading and visible):
		fading=true
		await get_tree().create_timer(1).timeout
		fading=false
		GameManager.interactedItem.unzoom()
		GameManager.playerTool=""

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	if(visible):
		collision=false
