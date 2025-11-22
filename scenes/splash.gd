extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.51).timeout
	$Transition.play("fadeOut")
	await get_tree().create_timer(2.6).timeout
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
