extends ColorRect

var collision=false
var water=0

var waterEmitting=false

func _process(delta: float) -> void:
	$Water.emitting=waterEmitting
	$Jug/Jug2/Jug3.position=Vector2(-13.0, 390.0).lerp(Vector2(-13.0, -160.0), float(water)/100.0)
	if($Water.emitting):
		if(GameManager.baseWater>0 and water<100 and $Jug.visible):
			GameManager.baseWater-=delta*10
			water+=delta*10
			if(GameManager.baseWater<0):
				water+=GameManager.baseWater
				GameManager.baseWater=0
			if(water>100):
				GameManager.baseWater+=water-100
				water=100
		else:
			$Water.emitting=false
	if(Input.is_action_just_pressed("Interact") and collision and len(GameManager.inventory)<=4 and $Jug.visible):
		GameManager.add("Jug", round(water))
		GameManager.pickedUpJugWater=water
		water=0
		$Jug.visible=false
	elif(Input.is_action_just_pressed("Interact") and collision and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]["name"]=="Jug" and $Jug.visible==false):
		water=GameManager.inventory[GameManager.selectedSlot]["count"]
		GameManager.inventory.remove_at(GameManager.selectedSlot)
		GameManager.pickedUpJugWater=-1
		GameManager.selectedSlot=-1
		$Jug.visible=true
func _on_area_2d_body_entered(_body: Node2D) -> void:
	collision=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	collision=false


func _on_button_pressed() -> void:
	waterEmitting=!waterEmitting
