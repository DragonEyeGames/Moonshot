extends CharacterBody2D


@export var  speed = 300.0

var canPickUp:=false
var pickable
var canPlace:=false
var currentlyHeld
var handHeldItem:=""
var pickedUpType:=""
var pickedUpParent
var pickedUp=false

func _ready() -> void:
	flashlightEvents()
	GameManager.playerHand=$CanvasLayer/OverlayArm/Bones/Skeleton2D/Base/Segment/Hand
	GameManager.playerAnimator=$StateController
	GameManager.hud=$HUD

func _process(_delta: float) -> void:
	$Area2D/CollisionShape2D.scale=Vector2(1/GameManager.camera.zoom.x, 1/GameManager.camera.zoom.y)
	if(GameManager.carrots>0 and not "Carrots" in GameManager.inventory and len(GameManager.inventory) <= 4):
		GameManager.inventory.append("Carrots")
	$CanvasLayer/OverlayArm/Sprites/Square4/tape.visible=GameManager.playerTool=="tape"
	$CanvasLayer/OverlayArm/Sprites/Square4/Square5.visible=GameManager.playerTool=="rag"
	$CanvasLayer/SeedBag.visible=GameManager.playerTool=="seedBag"
	$CanvasLayer/PlantBag.visible=GameManager.playerTool=="bag"
	$CanvasLayer/OverlayArm/Sprites/Square4/wateringCan.visible=GameManager.playerTool=="wateringCan"
	if(handHeldItem=="seeds" and Input.is_action_just_released("Click")):
		GameManager.interactedItem.dropSeeds()
		handHeldItem=""
		$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(1, 1)
	$"CanvasLayer/OverlayArm/IK Targets/TIP".global_position=get_viewport().get_mouse_position()
	$Area2D.global_position=get_global_mouse_position()
	$Helmet/PointLight2D.look_at(get_global_mouse_position())
	$Helmet/PointLight2D.rotation+=PI/2
	if(Input.is_action_just_pressed("Flashlight")):
		GameManager.flashlightOn=!GameManager.flashlightOn
	if(GameManager.playerEnergy<=0 and GameManager.flashlightOn):
		GameManager.flashlightOn=false
	$Helmet/PointLight2D.enabled=GameManager.flashlightOn
	if(GameManager.playerSprinting):
		speed=600
	else:
		speed=300
	velocity = Input.get_vector("Left", "Right", "Up", "Down")
	var healthMod = float(GameManager.health/100.0)
	if(healthMod<.6):
		healthMod=.6
	velocity*=speed*healthMod
	if(GameManager.playerMove):
		move_and_slide()
	if(canPickUp and pickedUp == false and Input.is_action_just_pressed("Click") and pickable!=null):
		#var world_pos=pickable.global_position
		pickable.freeze=true
		pickedUp=true
		pickedUpParent=pickable.get_parent()
		var oldPos = pickable.global_position
		pickable.reparent($CanvasLayer/OverlayArm/Sprites/Square4)
		#pickable.rotation+=PI/2
		handHeldItem=pickedUpType.to_lower()
		currentlyHeld=pickable
		pickable.scale*=GameManager.camera.zoom
		#pickable.scale*=GameManager.camera.zoom
		pickable.position=$CanvasLayer/OverlayArm/Sprites/Square4/Position.position
		await get_tree().create_timer(.1).timeout
	if(Input.is_action_just_released("Click") and pickable!=null and pickedUp):
		pickedUp=false
		var screenPos=pickable.global_position
		pickable.reparent(pickedUpParent)
		pickable.scale/=GameManager.camera.zoom
		pickable.global_position=get_canvas_transform().affine_inverse() * screenPos
		pickable.freeze=false
		pickable=null
		handHeldItem=""
		
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
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and handHeldItem=="" and GameManager.playerTool=="bag"):
		canPickUp=true
		pickedUpType=area.name
		pickable=area.get_parent()
			
func pickUp(item):
	$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(.9, .9)
	handHeldItem=item
