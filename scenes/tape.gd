extends Node2D

var currentLine=null

func _process(delta: float) -> void:
	global_rotation_degrees=90
	if(Input.is_action_just_pressed("Click") and visible):
		currentLine = Line2D.new()
		GameManager.tapeHolder.add_child(currentLine)
		currentLine.add_point(GameManager.tapeHolder.to_local(get_viewport().get_canvas_transform().affine_inverse() * ($TapeStart.global_position)))
		currentLine.add_point(GameManager.tapeHolder.to_local(get_viewport().get_canvas_transform().affine_inverse() * ($TapeStart.global_position)))
		currentLine.width=10
		currentLine.z_index=1
		currentLine.default_color=Color(0, 0, 0)
		print(currentLine.get_point_position(0))
		print(currentLine.get_point_position(1))
	if(currentLine!=null):
		currentLine.set_point_position(1, GameManager.tapeHolder.to_local(get_viewport().get_canvas_transform().affine_inverse() * ($TapeStart.global_position)))
	if(Input.is_action_just_released("Click") and visible):
		currentLine=null
