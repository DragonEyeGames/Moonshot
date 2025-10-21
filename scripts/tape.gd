extends Node2D

var currentLine: Line2D = null

var usedTape=0
var currentUsedTape=0
var tapeLeft=500

enum State {
	IDLE,
	SELECTED,
	TAPING
}

var currentState: State = State.IDLE

func _physics_process(_delta: float) -> void:
	perFrameUpdates()
	match currentState:
		State.IDLE:
			idle()
		State.SELECTED:
			selected()
			checkOver()
		State.TAPING:
			taping()
			checkOver()


func _on_tape_entered(body: Node) -> void:
	body.get_parent().coverings+=1
		
func _on_tape_exited(body: Node) -> void:
	body.get_parent().coverings-=1
	
func perFrameUpdates():
	tapeLeft=500-currentUsedTape-usedTape
	# Step 1: map proportionally
	var mapped = 0.4 + (tapeLeft - 0) * (1.2 - 0.4) / (500 - 0)
	# Step 2: clamp between low_out and high_out
	mapped = clamp(mapped, .4, 1.2)
	$".".scale.x=mapped
	global_rotation_degrees = 90
	
func checkOver():
	print(GameManager.playerTool)
	if(GameManager.playerTool!="tape" ):
		currentState=State.IDLE
		if(tapeLeft>0):
			GameManager.inventory.append({"name": "Tape", "count": tapeLeft/100*3})
		tapeLeft=0
		currentUsedTape=0
		usedTape=0

func idle():
	if(visible and GameManager.playerTool=="tape" and GameManager.selectedSlot!=-1):
		tapeLeft=GameManager.inventory[GameManager.selectedSlot]["count"]*100/3
		GameManager.inventory.remove_at(GameManager.selectedSlot)
		usedTape=0
		currentUsedTape=0
		GameManager.selectedSlot=-1
		currentState=State.SELECTED
		
func selected():
	if Input.is_action_just_pressed("Click") and $"../../..".modulate.a>0 and tapeLeft>0:
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
		
		#Change State
		currentState=State.TAPING


func taping():
	if currentLine != null:
		updateLine()

	if Input.is_action_just_released("Click") and $"../../..".modulate.a>0 and visible:
		endLine()
		
func updateLine():
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
		
	var startPos = currentLine.points[0]
	var endPos = currentLine.points[1]
	var distance = startPos.distance_to(endPos)
	currentUsedTape=distance
	tapeLeft=500-currentUsedTape-usedTape
	if(tapeLeft<=0):
		tapeLeft=0
		currentLine = null
		usedTape+=currentUsedTape
		currentUsedTape=0
		
func endLine():
	currentLine = null
	usedTape+=currentUsedTape
	currentUsedTape=0
	currentState=State.SELECTED
