extends ColorRect

var collision=false
var seeds=3

func _process(delta: float) -> void:
	print(seeds)
	if(collision and Input.is_action_just_pressed("Click") and seeds>0):
		GameManager.player.pickUp("seeds")
		seeds-=1
	elif(collision and Input.is_action_just_released("Click") and seeds<=0):
		await get_tree().create_timer(1).timeout
		GameManager.playerAnimator.play("fadeToArm")

func _on_area_2d_area_entered(area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(area: Area2D) -> void:
	if(visible):
		collision=false
