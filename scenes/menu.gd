extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Click") and $HowTo.visible):
		$HowTo.visible=false


func _on_start_pressed() -> void:
	$ColorRect2/AnimationPlayer.play("out")
	await get_tree().create_timer(1.1).timeout
	get_tree().change_scene_to_file("res://scenes/Main.tscn")


func _on_how_pressed() -> void:
	$HowTo.visible=true
