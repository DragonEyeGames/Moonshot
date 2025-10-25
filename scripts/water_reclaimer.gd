extends ElectronicZoom

var filterEntered:=false
var filterDragging:=false
var innerFilterDragging:=false
var offset
var innerOffset

var filterZoomEntered:=false

var filterItemEntered:=false

var filterDoorEntered:=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(GameManager.baseHumidity>200):
		efficiency=.8
		maxPower=1.5
	elif(GameManager.baseHumidity>50):
		efficiency=1.1
		maxPower=.7
	else:
		efficiency=1.2
		maxPower=.15
	efficiency =  1 - ((maxPower/2)-.5)
	efficiency*=4
	maxPower=maxPower/efficiency
	if(overriden):
		maxPower=$ProgressBar.value
		efficiency =  (1 - (($ProgressBar.value/2)-.5))*4
		$ColorRect2.color=Color(1, 0, 0)
		maxPower=maxPower/efficiency
		print(maxPower)
	else:
		$ColorRect2.color=Color(.05, .05, .05)
	$ProgressBar.editable=overriden
	power=maxPower
	powerSap(delta)
	if(GameManager.baseHumidity>power):
		GameManager.baseHumidity-=power
		GameManager.baseWater+=power
	$ColorRect/RichTextLabel.text=str(round(GameManager.baseWater*100)/100)
	$ColorRect4/RichTextLabel.text=str(round(power/delta*100)/100)
	$ColorRect3/RichTextLabel.text=str(round(efficiency*100)/100)
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and not zoomed):
		zoom("fadeToArm")
		GameManager.collisionTool=self
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and canZoom and zoomed):
		unzoom("revealToArm")
	if(Input.is_action_just_pressed("Click") and not filterDragging and filterEntered):
		filterDragging=true
		offset=$Control/ColorRect.global_position.x-GameManager.mousePos.x
	elif(Input.is_action_just_released("Click") and filterDragging):
		filterDragging=false
	if(filterDragging):
		$Control/ColorRect.global_position.x=GameManager.mousePos.x+offset
		if($Control/ColorRect.position.x<-50):
			$Control/ColorRect.position.x=-50
		elif($Control/ColorRect.position.x>26):
			$Control/ColorRect.position.x=26
	if(Input.is_action_just_pressed("Click") and not innerFilterDragging and filterDoorEntered):
		innerFilterDragging=true
		print("clic")
		innerOffset=$Control/ColorRect3/Control/Door.global_position.y-GameManager.mousePos.y
	elif(Input.is_action_just_released("Click") and innerFilterDragging):
		innerFilterDragging=false
	if(innerFilterDragging):
		$Control/ColorRect3/Control/Door.global_position.y=GameManager.mousePos.y+innerOffset
		if($Control/ColorRect3/Control/Door.position.y>32):
			$Control/ColorRect3/Control/Door.position.y=32
			var collisionPolygon=$Control/ColorRect3/ColorRect/Filter/Filter/CollisionPolygon2D2
			if(collisionPolygon!=null):
				$Control/ColorRect3/ColorRect/Filter/Filter/CollisionPolygon2D2.disabled=false
		elif($Control/ColorRect3/Control/Door.position.y<0):
			$Control/ColorRect3/Control/Door.position.y=0
	if(filterZoomEntered and Input.is_action_just_pressed("Click")):
		extraZoom()
		
func extraZoom():
	GameManager.zoomCamera($ExtraZoomPoint, 15)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	await get_tree().create_timer(1.1).timeout
	$MouseCover.visible=false
	canZoom=true
	GameManager.playerTool="bag"

func extraUnzoom(type="appear"):
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	$ColorRect5.visible=true
	GameManager.playerAnimator.play(type)
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true


func _on_button_pressed() -> void:
	overriden=!overriden


func _on_handle_mouse_entered() -> void:
	filterEntered=true


func _on_handle_mouse_exited() -> void:
	filterEntered=false


func _filter_mouse_entered() -> void:
	filterZoomEntered=true


func _filter_mouse_exited() -> void:
	filterZoomEntered=false


func _filter_door_entered() -> void:
	filterDoorEntered=true


func _filter_door_exited() -> void:
	filterDoorEntered=false


func _on_area_2d_area_entered(area: Area2D) -> void:
	print("HHAAUALAAL")
	if("Filter" in area.name):
		area.get_parent().freeze=true
		area.get_parent().scale=Vector2(.75, .75)
		area.get_parent().position=Vector2(23, 11)
	else:
		print(area.name)
