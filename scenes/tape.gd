extends Node2D

var currentLine: Line2D = null

func _physics_process(delta: float) -> void:
	global_rotation_degrees = 90

	if Input.is_action_just_pressed("Click") and visible:
		# --- Create the line ---
		currentLine = Line2D.new()
		GameManager.tapeHolder.add_child(currentLine)
		var start_pos = GameManager.tapeHolder.to_local(get_viewport().get_canvas_transform().affine_inverse() * $TapeStart.global_position)
		currentLine.add_point(start_pos)
		currentLine.add_point(start_pos)
		currentLine.width = 10
		currentLine.z_index = 1
		currentLine.default_color = Color.BLACK

		# --- Create the Area2D and CollisionPolygon2D ---
		var area = Area2D.new()
		area.collision_layer = 0
		area.collision_mask = 128
		area.monitorable=true
		area.monitoring=true
		currentLine.add_child(area)

		var poly = CollisionPolygon2D.new()
		area.add_child(poly)

		# --- Connect the signal ---
		area.area_entered.connect(_on_tape_entered)
		area.area_exited.connect(_on_tape_exited)

		# --- Store area and polygon for updating later ---
		currentLine.set_meta("area", area)
		currentLine.set_meta("poly", poly)

	if currentLine != null:
		# --- Update the line and collision polygon as you drag ---
		var start = currentLine.points[0]
		var end = GameManager.tapeHolder.to_local(get_viewport().get_canvas_transform().affine_inverse() * $TapeStart.global_position)
		currentLine.set_point_position(1, end)

		var poly: CollisionPolygon2D = currentLine.get_meta("poly")
		if poly:
			var width = currentLine.width / 2.0
			var dir = (end - start).normalized()
			var perp = Vector2(-dir.y, dir.x) * width
			poly.polygon = [
				start + perp,
				start - perp,
				end - perp,
				end + perp
			]

	if Input.is_action_just_released("Click") and visible:
		currentLine = null


func _on_tape_entered(body: Node) -> void:
	if(body.get_parent().get_node("airflow").emitting):
		body.get_parent().get_node("airflow").emitting=false
		
func _on_tape_exited(body: Node) -> void:
	if(body.get_parent().get_node("airflow").emitting==false):
		body.get_parent().get_node("airflow").emitting=true
