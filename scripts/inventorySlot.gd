extends Control

@export var slotIndex=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(len(GameManager.inventory)>=slotIndex+1):
		visible=true
		$Count.text=str(GameManager.inventory[slotIndex]["count"])
		if(GameManager.inventory[slotIndex]["name"]=="Jug"):
			$InventoryItems.get_node(GameManager.inventory[slotIndex]["name"]).get_child(0).text=str(round(GameManager.inventory[slotIndex]["count"]*100)/100) + " Water(s)"
		for child in $InventoryItems.get_children():
			child.visible=false
		#print(GameManager.inventory[slotIndex])
		$InventoryItems.get_node(GameManager.inventory[slotIndex]["name"]).visible=true
		if(GameManager.selectedSlot==slotIndex):
			$Outline.visible=true
			var itemSelected = GameManager.inventory[slotIndex]["name"]
			if(Input.is_action_just_pressed("Interact") and itemSelected in GameManager.instants):
				if(itemSelected=="IceCream"):
					GameManager.food+=12
					GameManager.subtract("IceCream", 1)
				elif(itemSelected=="Protein"):
					GameManager.food+=8
					GameManager.subtract("Protein", 1)
				elif(itemSelected=="H Mac"):
					GameManager.food+=20
					GameManager.water+=10
					GameManager.subtract("H Mac", 1)
				elif(itemSelected=="H Cup"):
					GameManager.water+=20
					GameManager.subtract("H Cup", 1)
					GameManager.add("Cup", 1)
				elif(itemSelected=="Carrot"):
					GameManager.water+=7.5
					GameManager.food+=15
					GameManager.carrots-=1
					if(GameManager.carrots<=0):
						GameManager.inventory.remove_at(slotIndex)
				GameManager.selectedSlot=-1
				$Outline.visible=false
		else:
			$Outline.visible=false
	else:
		visible=false


func _on_button_pressed() -> void:
	GameManager.selectedSlot=slotIndex
	
func maxOut():
	$AnimationPlayer.play("tooMany")
