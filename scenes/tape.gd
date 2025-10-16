extends Node2D

var currentLine

func _process(delta: float) -> void:
	global_rotation_degrees=90
	if(Input.is_action_just_pressed("Click") and visible):
		currentLine = Line2D.new()
		currentLine.add_point(GameManager.tapeHolder.to_local($TapeStart.global_position))
		GameManager.tapeHolder.add_child(currentLine)
		currentLine.add_point(GameManager.tapeHolder.to_local($TapeStart.global_position)*1.1)
		print(currentLine.get_point_position(0))
