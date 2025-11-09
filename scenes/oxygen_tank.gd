extends ColorRect

var colliding=false
var zoomed=false
var canZoom=true
var handEntered=false
var dragging:=false
var dragOffset := Vector2.ZERO
var destinationEntered=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#prints(zoomed, len(GameManager.inventory)>4)
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom ):
			GameManager.interactedItem=null
			zoom()
		elif(zoomed and canZoom):
			unzoom()
	if(dragging):
		$Port/Line2D.points[1]=$Port/Line2D.to_local(get_global_mouse_position()+dragOffset)
		$Port/Area2D.global_position=get_global_mouse_position()
			
	if(handEntered and Input.is_action_just_pressed("Click")):
		dragging=true
		dragOffset=get_global_mouse_position()-$Port/Area2D.global_position
		if(len($Port/Line2D.points)==1):
			$Port/Line2D.add_point($Port/Line2D.to_local(get_global_mouse_position()+dragOffset))
		else:
			$Port/Line2D.points[1]=$Port/Line2D.to_local(get_global_mouse_position()+dragOffset)
	elif(handEntered and Input.is_action_just_released("Click")):
		dragging=false
		dragOffset=Vector2.ZERO
		if(not destinationEntered):
			$Port/Line2D.remove_point(1)
			$Port/Area2D.position=Vector2(42, 42)
		else:
			$Port/Line2D.points[1]=$Port/Line2D.to_local($Backpack/Area2D.global_position)
			$Port/Area2D.global_position=$Backpack/Area2D.global_position
			


func _body_entered(_body: Node2D) -> void:
	colliding=true


func _body_exited(_body: Node2D) -> void:
	colliding=false
	
func zoom():
	$Backpack.visible=true
	GameManager.zoomCamera($ZoomPoint, 3.5)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.player.handHeldItem=""
	GameManager.playerTool=""
	GameManager.collisionTool=self
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	$Backpack.visible=false
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerMove=true
	GameManager.playerTool=""
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	canZoom=true


func _on_area_2d_mouse_entered() -> void:
	handEntered=true


func _on_area_2d_mouse_exited() -> void:
	handEntered=false


func _recepticle_mouse_entered() -> void:
	if(dragging):
		destinationEntered=true


func _recepticle_mouse_exited() -> void:
	destinationEntered=false
