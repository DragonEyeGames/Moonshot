extends CharacterBody2D


@export var  speed = 300.0

func _ready() -> void:
	flashlightEvents()
	GameManager.playerAnimator=$StateController

func _process(delta: float) -> void:
	$CanvasLayer/OverlayArm/Sprites/Square4/Square5.visible=GameManager.playerTool=="rag"
	print(GameManager.baseCarbon)
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
	var healthMod = GameManager.health/100
	if(healthMod<.6):
		healthMod=.6
	velocity*=speed*healthMod
	if(GameManager.playerMove):
		move_and_slide()

func flashlightEvents():
	await get_tree().create_timer(randf_range(.05*GameManager.playerEnergy, .2*GameManager.playerEnergy)).timeout
	if(GameManager.flashlightOn):
		$Helmet/PointLight2D.energy=randf_range(0, .5)
		await get_tree().create_timer(randf_range(.1, .2)).timeout
		$Helmet/PointLight2D.energy=1
	flashlightEvents()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if($CanvasLayer/OverlayArm.modulate.a>=.9 and area.get_parent().visible):
		area.get_parent().modulate.a-=.5
		if(area.get_parent().modulate.a<=.1):
			area.get_parent().queue_free()
