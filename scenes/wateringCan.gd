extends Node2D

var pouring=false

func _process(delta: float) -> void:
	if(visible):
		if(GameManager.playerHand.get_child(0).update_rotation):
			GameManager.playerHand.rotation=0
			GameManager.playerHand.get_child(0).update_rotation=false
			get_parent().rotation=0
		print(get_parent().rotation)
		if(Input.is_action_just_pressed("Click")):
			var tween=create_tween()
			tween.tween_property(get_parent(), "rotation", deg_to_rad(-40), .3)
			await get_tree().create_timer(.4).timeout
			pouring=true
		elif(Input.is_action_just_released("Click")):
			var tween=create_tween()
			tween.tween_property(get_parent(), "rotation", deg_to_rad(0), .3)
			pouring=false
		$CPUParticles2D.emitting=pouring
