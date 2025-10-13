extends ColorRect

var collision=false

func _process(delta: float) -> void:
	if(collision and Input.is_action_just_pressed("Interact")):
		GameManager.player.pickUp("seeds")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(visible):
		collision=false
