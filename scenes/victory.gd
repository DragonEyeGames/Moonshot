extends Control


func _on_start_pressed() -> void:
	$ColorRect/AnimationPlayer.play("out")
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
