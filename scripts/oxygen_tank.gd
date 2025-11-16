extends Node2D

var colliding=false
var zoomed=false
var canZoom=true
var handEntered=false
var dragging:=false
var dragOffset := Vector2.ZERO
var destinationEntered=false
var leverEntered=false
var dragObject:=""
var connected:=false
var on:=false
@export var minimum: int = 1
@export var maximum: int = 4
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.player.global_position.y>self.global_position.y):
		z_index=minimum
	else:
		z_index=maximum
	$Backpack/Counter/RichTextLabel.text=str(round(int(GameManager.oxygen)))
	$Counter/RichTextLabel.text=str(round(int(GameManager.baseOxygen)))
	#prints(zoomed, len(GameManager.inventory)>4)
	if(not connected):
		$ColorRect2/ConnectedLight.color=Color.RED
	else:
		$ColorRect2/ConnectedLight.color=Color.LIME_GREEN
	if($ColorRect2/Line2D.points[1].y>$ColorRect2/Line2D.points[0].y):
		$ColorRect2/OnLight.color=Color.LIME_GREEN
		on=true
	else:
		$ColorRect2/OnLight.color=Color.DIM_GRAY
		on=false
	if(on and connected):
		GameManager.baseOxygen-=delta*5
		GameManager.oxygen+=delta*5
		if(GameManager.baseOxygen<0):
			GameManager.oxygen+=GameManager.baseOxygen
			GameManager.baseOxygen=0
		if(GameManager.oxygen>100):
			GameManager.baseOxygen+=GameManager.oxygen-100
			GameManager.oxygen=100
	elif(on and not connected):
		GameManager.baseOxygen-=delta*5
		GameManager.baseCarbon+=delta*5
		if(GameManager.baseOxygen<0):
			GameManager.baseCarbon+=GameManager.baseOxygen
			GameManager.baseOxygen=0
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom ):
			GameManager.interactedItem=null
			zoom()
		elif(zoomed and canZoom):
			unzoom()
	if($Backpack.visible==false and len($Port/Line2D.points)>=2):
		$Port/Line2D.remove_point(1)
		$Port/Area2D.global_position=$Port/Line2D.global_position
		connected=false
	if(dragging and dragObject=="pipe"):
		$Port/Line2D.points[1]=$Port/Line2D.to_local(get_global_mouse_position()+dragOffset)
		$Port/Area2D.global_position=get_global_mouse_position()
	elif(dragging and dragObject=="lever"):
		$ColorRect2/Area2D.global_position=get_global_mouse_position()+dragOffset
		$ColorRect2/Line2D.points[1]=$ColorRect2/Line2D.to_local(Vector2(48, $ColorRect2/Area2D.global_position.y))
		$ColorRect2/Line2D.points[1]=Vector2(48,$ColorRect2/Line2D.points[1].y)
		if(abs($ColorRect2/Line2D.points[1].y-$ColorRect2/Line2D.points[0].y)>72):
			if($ColorRect2/Line2D.points[1].y-$ColorRect2/Line2D.points[0].y>0):
				$ColorRect2/Line2D.points[1].y=$ColorRect2/Line2D.points[0].y+72
			elif($ColorRect2/Line2D.points[1].y-$ColorRect2/Line2D.points[0].y<0):
				$ColorRect2/Line2D.points[1].y=$ColorRect2/Line2D.points[0].y-72
		$ColorRect2/Area2D.global_position=($ColorRect2/Line2D.to_global($ColorRect2/Line2D.points[1]))
				
	if(handEntered and Input.is_action_just_pressed("Click")):
		dragging=true
		connected=false
		dragObject="pipe"
		dragOffset=get_global_mouse_position()-$Port/Area2D.global_position
		if(len($Port/Line2D.points)==1):
			$Port/Line2D.add_point($Port/Line2D.to_local(get_global_mouse_position()+dragOffset))
		else:
			$Port/Line2D.points[1]=$Port/Line2D.to_local(get_global_mouse_position()+dragOffset)
	elif(handEntered and Input.is_action_just_released("Click")):
		dragging=false
		dragObject=""
		dragOffset=Vector2.ZERO
		if(not destinationEntered):
			connected=false
			$Port/Line2D.remove_point(1)
			$Port/Area2D.position=Vector2(42, 42)
		else:
			connected=true
			$Port/Line2D.points[1]=$Port/Line2D.to_local($Backpack/Area2D.global_position)
			$Port/Area2D.global_position=$Backpack/Area2D.global_position
	if(leverEntered and Input.is_action_just_pressed("Click")):
		dragging=true
		dragObject="lever"
		dragOffset=get_global_mouse_position()-$ColorRect2/Area2D.global_position
		$ColorRect2/Line2D.points[1]=$ColorRect2/Line2D.to_local(Vector2($ColorRect2/Area2D.global_position))
		$ColorRect2/Line2D.points[1]=Vector2(48,$ColorRect2/Line2D.points[1].y)
	elif(dragObject=="lever" and Input.is_action_just_released("Click")):
		dragging=false
		dragObject=""
		dragOffset=Vector2.ZERO


func _body_entered(body: Node2D) -> void:
	if(body is Player):
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


func _lever_entered() -> void:
	leverEntered=true


func _lever_exited() -> void:
	leverEntered=false
