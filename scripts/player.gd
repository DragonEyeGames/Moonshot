extends CharacterBody2D
class_name Player

@export var  speed = 300.0

#If the play can pick up an item. Used when an item is hovered to let the player know if it is even a valid option
var canPickUp:=true

#This is one of the most important things. It is the picked up item itself.
var pickable: Node2D

#The item (type) being held
var handHeldItem:=""

#Whether or not there is an item in the players hand
var pickedUp=false

#Whether or not the bag that items can be deposited in is open
var bagOpen=false

#Packed Scenes
@export var filter: PackedScene

func _ready() -> void:
	flashlightEvents()
	GameManager.playerHand=$CanvasLayer/OverlayArm/Bones/Skeleton2D/Base/Segment/Hand
	GameManager.playerAnimator=$StateController
	GameManager.hud=$HUD

func _process(_delta: float) -> void:
	perFrameUpdate()
	seedCheck()
	flashlight()
	sprintCheck()
	movement()
	
func _physics_process(_delta: float) -> void:
	#All of the fun interactions with moving stuff to and fro shelves
	if(pickedUp == false and Input.is_action_just_pressed("Click") and pickable!=null):
		canPickUp=false
		if(bagOpen==false):
			await closedBagPickup()
		else:
			await openBagPickup()
	elif(Input.is_action_just_released("Click") and pickable!=null and pickedUp and not ($CanvasLayer/PlantBag.collision and bagOpen==false)):
		if(bagOpen==false):
			await closedBagDrop()
		else:
			await openBagDrop()
		pickable=null
		pickedUp=false
		handHeldItem=""
		await get_tree().create_timer(.05).timeout
		canPickUp=true
		
func flashlightEvents():
	await get_tree().create_timer(randf_range(.05*GameManager.playerEnergy, .2*GameManager.playerEnergy)).timeout
	if(GameManager.flashlightOn):
		$Helmet/PointLight2D.energy=randf_range(0, .5)
		await get_tree().create_timer(randf_range(.1, .2)).timeout
		$Helmet/PointLight2D.energy=1
	flashlightEvents()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and area.name=="SpeckleArea"):
		area.get_parent().modulate.a-=.5
		if(area.get_parent().modulate.a<=.1):
			area.get_parent().queue_free()
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and GameManager.playerTool=="bag" and bagOpen==false):
		if(canPickUp):
			handHeldItem=area.name
			pickable=area.get_parent()

func pickUp(item):
	$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(.9, .9)
	handHeldItem=item


func _on_area_2d_area_exited(area: Area2D) -> void:
	await get_tree().create_timer(.05).timeout
	if(not area):
		return
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and GameManager.playerTool=="bag"):
		if(pickable==area.get_parent() and not pickedUp):
			pickable=null
			handHeldItem=""
		else:
			print(pickable)


func _in_bag_entered(area: Area2D) -> void:
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and handHeldItem=="" and GameManager.playerTool=="bag" and bagOpen==true):
		if canPickUp:
			handHeldItem=area.name
			pickable=area.get_parent()
			var oldParent=area.get_parent().get_parent()
			pickable.call_deferred("reparent", $CanvasLayer/PlantBag)
			if(oldParent!=$CanvasLayer/PlantBag):
				oldParent.queue_free()


func _in_bag_exited(area: Area2D) -> void:
	await get_tree().create_timer(.1).timeout
	if(not area):
		return
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and handHeldItem=="" and GameManager.playerTool=="bag" and bagOpen==true):
		if(pickable==area.get_parent()):
			pickable=null

func seedCheck():
	if(handHeldItem=="seeds" and Input.is_action_just_released("Click")):
		GameManager.interactedItem.dropSeeds()
		handHeldItem=""
		$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(1, 1)
		
func perFrameUpdate():
	#Set the areas properties so it collision as if in a canvas layer at mouse pos
	$Area2D/CollisionShape2D.scale=Vector2(1/GameManager.camera.zoom.x, 1/GameManager.camera.zoom.y)
	$Area2D.global_position=get_canvas_transform().affine_inverse() * $CanvasLayer/OverlayArm/Sprites/Square4.global_position
	$Area2D.rotation=$CanvasLayer/OverlayArm/Sprites/Square4.rotation
	
	#Visisble the tools
	$CanvasLayer/OverlayArm/Sprites/Square4/tape.visible=GameManager.playerTool=="tape"
	$CanvasLayer/OverlayArm/Sprites/Square4/Square5.visible=GameManager.playerTool=="rag"
	if($Area2D/CollisionShape2D2.disabled==(GameManager.playerTool=="rag")):
		$Area2D/CollisionShape2D2.set_deferred("disabled", not GameManager.playerTool=="rag")
	
	$CanvasLayer/SeedBag.visible=GameManager.playerTool=="seedBag"
	$CanvasLayer/PlantBag.visible=GameManager.playerTool=="bag"
	
	#Move the arm
	$"CanvasLayer/OverlayArm/IK Targets/TIP".global_position=get_viewport().get_mouse_position()

	
func flashlight():
	$Helmet/PointLight2D.look_at(get_global_mouse_position())
	$Helmet/PointLight2D.rotation+=PI/2
	if(Input.is_action_just_pressed("Flashlight")):
		GameManager.flashlightOn=!GameManager.flashlightOn
	if(GameManager.playerEnergy<=0 and GameManager.flashlightOn):
		GameManager.flashlightOn=false
	$Helmet/PointLight2D.enabled=GameManager.flashlightOn
	
func sprintCheck():
	if(GameManager.playerSprinting):
		speed=600
	else:
		speed=300
		
func movement():
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	var healthMod = float(GameManager.health/100.0)
	if(healthMod<.6):
		healthMod=.6
	velocity*=speed*healthMod
	if(GameManager.playerMove):
		move_and_slide()
		
func closedBagPickup():
	handHeldItem=str(pickable.get_child(-1).name)
	$CanvasLayer/PlantBag.loadInventory()
	if(not maxedInventory(handHeldItem)):
		$CanvasLayer/PlantBag.get_node("full").play("full")
		canPickUp=false
		handHeldItem=""
		pickable=null
		return
	if(pickable==null):
		return
	#var world_pos=pickable.global_position
	pickable.queue_free()
	pickedUp=true
	#var oldPos = pickable.global_position
	pickable = filter.instantiate()
	$CanvasLayer/OverlayArm/Sprites/Square4.add_child(pickable)
	#pickable.rotation+=PI/2
	for child in pickable.get_children():
		child.scale*=3.8
	#pickable.scale*=GameManager.camera.zoom
	pickable.position=$CanvasLayer/OverlayArm/Sprites/Square4/Position.position

func openBagPickup():
	pickedUp=true
	if(handHeldItem=="BagItem"):
		var oldPickable=pickable
		pickable=oldPickable.duplicate(true)
		pickable.scale=Vector2(1, 1)
		oldPickable.get_parent().add_child(pickable)
		#pickable.get_node("BagItem").name=oldPickable.name
		oldPickable.queue_free()
		pickable.visible=true
	pickable.reparent($CanvasLayer/OverlayArm/Sprites/Square4)
	
func closedBagDrop():
	if(pickable==null):
		return
	$CanvasLayer/PlantBag.loadInventory()
	pickable.set_deferred("freeze", true)
	await get_tree().create_timer(0).timeout
	var screenPos=pickable.global_position
	pickable.reparent(GameManager.collisionTool)
	for child in pickable.get_children():
		child.scale/=GameManager.camera.zoom
	pickable.global_position=get_canvas_transform().affine_inverse() * screenPos
	await get_tree().create_timer(0).timeout
	if(pickable):
		pickable.set_deferred("freeze", false)
	await get_tree().create_timer(0).timeout
	pickable=null
	handHeldItem=""

func openBagDrop():
	if(handHeldItem=="BagItem"):
		for child in pickable.get_children():
			if(child.visible):
				handHeldItem=child.name
				break
	$CanvasLayer/PlantBag.newItem(handHeldItem, pickable.global_position, $CanvasLayer/OverlayArm/Sprites/Square4.rotation)
	var pickableSafe=pickable
	pickableSafe.queue_free()
	pickable=null
	
func maxedInventory(item) -> bool:
	if(len(GameManager.inventory)>4):
		for child in GameManager.inventory:
			if child["name"]==item:
				return true
		return false
	else:
		return true
