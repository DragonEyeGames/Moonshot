extends ColorRect

var collision=false
var jugCollision=false
var zoomed=false
var canZoom=true
var state="unplanted"

var water=100
var standingWater=0

func _process(delta: float) -> void:
	if(collision and state=="unplanted" and Input.is_action_just_pressed("Interact") and not zoomed and canZoom and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]=="Seeds"):
		GameManager.inventory.erase("Seeds")
		GameManager.playerTool="seedBag"
		state="planted"
		zoom()
	#elif(collision and Input.is_action_just_pressed("Interact") and not zoomed and canZoom and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]=="Watering Can"):
		#GameManager.inventory.erase("Watering Can")
		#GameManager.playerTool="wateringCan"
		#zoom()
	elif(jugCollision and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]=="Jug" and $ColorRect6/WurterJug.visible==false):
		GameManager.inventory.erase("Jug")
		$ColorRect6/WurterJug.visible=true
		water=GameManager.pickedUpJugWater
		GameManager.pickedUpJugWater=-1
	elif(collision and not jugCollision and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and not zoomed and canZoom):
		GameManager.playerTool="bag"
		zoom()
	elif(jugCollision and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and len(GameManager.inventory)<=4):
		GameManager.inventory.append("Jug")
		$ColorRect6/WurterJug.visible=false
		GameManager.pickedUpJugWater=water
		water=0
	#for child in $"Seed Storage".get_children():
		#if(child.modulate.a>.1):
			#child.modulate.a-=delta/10
	if(len($"Seed Storage".get_children())<=0 and state=="planted"):
		state="unplanted"
	
	if($ColorRect6/WurterJug.visible and water>0):
		if(water>0):
			standingWater+=delta*10
			water-=delta*10
			if(water<0):
				standingWater-=abs(water)
				water=0
			#print(water)
	$ColorRect7.modulate.a=standingWater/200

func _on_area_2d_body_entered(_body: Node2D) -> void:
	collision=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	collision=false
	
func dropSeeds():
	var dropper=$SeedDropper.duplicate()
	dropper.visible=true
	add_child(dropper)
	dropper.global_position=get_global_mouse_position()
	dropper.placed=true
	
func zoom():
	GameManager.selectedSlot=-1
	GameManager.zoomCamera($ZoomPoint, 3)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.interactedItem=self
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


func _on_jug_body_entered(_body: Node2D) -> void:
	jugCollision=true


func _on_jug_body_exited(_body: Node2D) -> void:
	jugCollision=false
