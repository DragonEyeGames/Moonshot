extends Node2D

var colliding=false
var zoomed=false
var canZoom=true
var entered=false
var dragging=false
var collided=false
var selectedWire=null
var selectedInt

var connectedWires=0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	flicker()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact") and canZoom and not zoomed):
		await zoom()
		$"Motion Controller".play("open")
	elif(colliding and Input.is_action_just_pressed("Interact") and canZoom and zoomed):
		await unzoom()
		$"Motion Controller".play("close")
	if(entered and Input.is_action_just_pressed("Click")):
		entered=false
		dragging=true
		selectedWire.add_point(selectedWire.to_local(get_global_mouse_position()))
	if(dragging):
		selectedWire.points[-1]=selectedWire.to_local(get_global_mouse_position())
		selectedWire.get_node("Area2D").global_position=get_global_mouse_position()
	if(Input.is_action_just_released("Click") and dragging):
		if(not collided):
			dragging=false
			selectedWire.remove_point(2)
			selectedWire.get_node("Area2D").position=Vector2(48, 81)
		else:
			dragging=false
			selectedWire.points[-1]=selectedWire.to_local($Hole.get_child(selectedInt+4).to_global($Hole.get_child(selectedInt+4).points[-1]))
			$Hole.get_child(selectedInt+4).add_point($Hole.get_child(selectedInt+4).to_local(selectedWire.to_global(selectedWire.points[-2])))
			selectedWire.get_node("Area2D").get_child(0).disabled=true
			connectedWires+=1
			$"Hole/Particle Holder".get_child(selectedInt).visible=false
			$"Hole/Particle Holder".get_child(selectedInt+4).visible=false
		
		selectedWire=null

func _on_area_2d_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false

func zoom():
	GameManager.zoomCamera($ZoomPoint, 5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.playerTool=""
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true


func _red_exited() -> void:
	entered=false
	#selectedWire=null
	#selectedInt=0
	
func flicker():
	await get_tree().create_timer(randf_range(4, 7)).timeout
	$"Hole/Particle Holder".get_child(randi_range(0, 7)).emitting=true
	flicker()


func _on_area_2d_area_entered(_area: Area2D) -> void:
	if(dragging):
		collided=true


func _on_area_2d_mouse_entered(line) -> void:
	entered=true
	if(selectedWire==null):
		selectedWire=$Hole.get_child(line)
		selectedInt=line
