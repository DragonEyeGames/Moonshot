extends ElectronicZoom

var filterEntered:=false
var filterDragging:=false
var innerFilterDragging:=false
var offset
var innerOffset

var filterZoomEntered:=false

var filterItemEntered:=false
var orderSwapping=false
var filterDoorEntered:=false
var childCount:=0
var mouseEntered:=false
var filterClean:=false
@export var filter: PackedScene
@export var cleanFilter: PackedScene

func _ready() -> void:
	childCount=len(get_children())
	GameManager.waterReclaimer=self
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
	else:
		$ColorRect2.color=Color(.05, .05, .05)
	$ProgressBar.editable=overriden
	power=maxPower
	powerSap(delta)
	if(not filterClean):
		power*=.3
		if($Control/ColorRect/Light/Status.current_animation=="good"):
			$Control/ColorRect/Light/Status.play("good_to_bad")
	else:
		if($Control/ColorRect/Light/Status.current_animation=="bad"):
			$Control/ColorRect/Light/Status.play("bad_to_good")
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
	if(GameManager.player.handHeldItem==""):
		outerFilter()
		innerFilter()
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


func _on_area_2d_mouse_entered() -> void:
	if not has_node("Control/ColorRect3/ColorRect/Filter/Filter/CollisionPolygon2D2"):
		mouseEntered=true

func innerFilter():
	if(Input.is_action_just_pressed("Click") and not innerFilterDragging and filterDoorEntered):
		innerFilterDragging=true
		innerOffset=$Control/ColorRect3/Control/Door.global_position.y-GameManager.mousePos.y
	elif(Input.is_action_just_released("Click") and innerFilterDragging):
		innerFilterDragging=false
	if(innerFilterDragging):
		$Control/ColorRect3/Control/Door.global_position.y=GameManager.mousePos.y+innerOffset
		if($Control/ColorRect3/Control/Door.position.y>32):
			$Control/ColorRect3/Control/Door.position.y=32
			if(has_node("Control/ColorRect3/ColorRect/Filter/Filter/CollisionPolygon2D2")):
				$Control/ColorRect3/ColorRect/Filter/Filter/CollisionPolygon2D2.disabled=false
		elif($Control/ColorRect3/Control/Door.position.y<0):
			$Control/ColorRect3/Control/Door.position.y=0
			
func outerFilter():
	if(Input.is_action_just_pressed("Click") and not filterDragging and filterEntered):
		filterDragging=true
		offset=$Control/ColorRect.global_position.x-GameManager.mousePos.x
	elif(Input.is_action_just_released("Click") and filterDragging):
		filterDragging=false
	if(filterDragging):
		$Control/ColorRect.global_position.x=GameManager.mousePos.x+offset
		if($Control/ColorRect.position.x<-375):
			$Control/ColorRect.position.x=-375
		elif($Control/ColorRect.position.x>-300):
			$Control/ColorRect.position.x=-300


func _on_child_order_changed() -> void:
	print("CHHANANGE")
	if(len(get_children())<childCount or orderSwapping):
		childCount=len(get_children())
		return
	orderSwapping=true
	childCount=len(get_children())
	print("UUNNONO")
	if(mouseEntered and len($Control/ColorRect3/ColorRect.get_children())==2):
		var child = get_child(-1)
		if(str(child.name)=="Filter"):
			filterClean=false
			child.queue_free()
			child=filter.instantiate()
			$Control/ColorRect3/ColorRect.add_child(child)
			child.set_deferred("freeze", true)
			child.set_deferred("global_position", Vector2(-2485.5, -3693.8))
			child.set_deferred("rotation", 0)
			child.set_deferred("scale", Vector2(0.75, 0.75))
			child.get_node("Filter").get_child(0).set_deferred("disabled", false)
		elif(str(child.name)=="CleanFilter"):
			filterClean=true
			child.queue_free()
			child=cleanFilter.instantiate()
			$Control/ColorRect3/ColorRect.add_child(child)
			child.set_deferred("freeze", true)
			child.set_deferred("global_position", Vector2(-2485.5, -3693.8))
			child.set_deferred("rotation", 0)
			child.set_deferred("scale", Vector2(0.75, 0.75))
			child.get_node("CleanFilter").get_child(0).set_deferred("disabled", false)
	orderSwapping=false


func _on_area_2d_mouse_exited() -> void:
	mouseEntered=false


func _on_area_2d_3_body_entered(body: Node2D) -> void:
	body.set_deferred("freeze", true)
	body.set_deferred("global_position", $Area2D3.global_position)
	body.set_deferred("linear_velocity", Vector2(0, 0))
	await get_tree().create_timer(.1).timeout
	body.set_deferred("freeze", false)


func _on_status_animation_finished(anim_name: StringName) -> void:
	if(anim_name=="good_to_bad"):
		$Control/ColorRect/Light/Status.play("bad")
	if(anim_name=="bad_to_good"):
		$Control/ColorRect/Light/Status.play("good")
	if(anim_name=="bad_to_horrible"):
		$Control/ColorRect/Light/Status.play("horrible")
	if(anim_name=="horrible_to_bad"):
		$Control/ColorRect/Light/Status.play("bad")
