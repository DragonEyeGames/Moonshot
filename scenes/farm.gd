extends ColorRect

var collision=false
var zoomed=false
var canZoom=true

func _process(delta: float) -> void:
	if(collision and Input.is_action_just_pressed("Interact") and not zoomed and canZoom and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]=="Seeds"):
		GameManager.inventory.erase("Seeds")
		GameManager.selectedSlot=-1
		GameManager.zoomCamera($ZoomPoint, 3)
		zoomed=true
		canZoom=false
		GameManager.playerMove=false
		GameManager.flashlightOn=false
		GameManager.playerTool="seedBag"
		GameManager.playerAnimator.play("fadeToArm")
		GameManager.interactedItem=self
		await get_tree().create_timer(1.1).timeout
		canZoom=true
	for child in $"Seed Storage".get_children():
		if(child.modulate.a>.1):
			child.modulate.a-=delta/10

func _on_area_2d_body_entered(body: Node2D) -> void:
	collision=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	collision=false
	
func dropSeeds():
	var dropper=$SeedDropper.duplicate()
	dropper.visible=true
	add_child(dropper)
	dropper.global_position=get_global_mouse_position()
	dropper.placed=true
	
func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	GameManager.playerMove=true
	canZoom=true
