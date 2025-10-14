extends CharacterBody2D


@export var  speed = 300.0

var canPickUp=false
var pickable
var canPlace=false

var handHeldItem=""

func _ready() -> void:
	flashlightEvents()
	GameManager.playerHand=$CanvasLayer/OverlayArm/Bones/Skeleton2D/Base/Segment/Hand
	GameManager.playerAnimator=$StateController

func _process(delta: float) -> void:
	$CanvasLayer/OverlayArm/Sprites/Square4/Square5.visible=GameManager.playerTool=="rag"
	$CanvasLayer/SeedBag.visible=GameManager.playerTool=="seedBag"
	$CanvasLayer/PlantBag.visile=GameManager.playerTool=="plantBag"
	$CanvasLayer/OverlayArm/Sprites/Square4/wateringCan.visible=GameManager.playerTool=="wateringCan"
	if(canPlace and Input.is_action_just_released("Click")):
		pickable.queue_free()
	if(handHeldItem=="seeds" and Input.is_action_just_released("Click")):
		GameManager.interactedItem.dropSeeds()
		handHeldItem=""
		$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(1, 1)
	$"CanvasLayer/OverlayArm/IK Targets/TIP".global_position=get_viewport().get_mouse_position()
	$Area2D.global_position=get_global_mouse_position()
	print($Area2D.visible)
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
	var healthMod = GameManager.health/100
	if(healthMod<.6):
		healthMod=.6
	velocity*=speed*healthMod
	if(GameManager.playerMove):
		move_and_slide()
	if(canPickUp and Input.is_action_just_pressed("Click") and pickable!=null):
		print("PPPPIIIIIIIIIIICCCCCCCCKKKKKKKKK            UUUUUUUUUPPPPPPPP")
		pickable.reparent($CanvasLayer/OverlayArm/Sprites/Square4)
		pickable.scale*=10
		pickable.rotation+=PI/2
		handHeldItem="plant"
		pickable.global_position=$CanvasLayer/OverlayArm/Sprites/Square4.global_position
		pickable=null
		
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
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and area.name=="Plant" and handHeldItem==""):
		canPickUp=true
		pickable=area.get_parent()
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible and area.name=="Bag" and handHeldItem=="plant"):
		canPlace=true
			
func pickUp(item):
	$CanvasLayer/OverlayArm/Sprites/Square4.scale=Vector2(.9, .9)
	handHeldItem=item
