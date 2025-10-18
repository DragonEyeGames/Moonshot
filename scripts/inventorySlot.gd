extends Control

@export var slotIndex=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(len(GameManager.inventory)>=slotIndex+1):
		visible=true
		if(GameManager.inventory[slotIndex]=="Carrots"):
			$InventoryItems.get_node(GameManager.inventory[slotIndex]).get_child(0).text=str(GameManager.carrots) + " Carrot(s)"
		if(GameManager.inventory[slotIndex]=="Jug"):
			$InventoryItems.get_node(GameManager.inventory[slotIndex]).get_child(0).text=str(round(GameManager.pickedUpJugWater*100)/100) + " Water(s)"
		for child in $InventoryItems.get_children():
			child.visible=false
		$InventoryItems.get_node(GameManager.inventory[slotIndex]).visible=true
		if(GameManager.selectedSlot==slotIndex):
			$Outline.visible=true
			var itemSelected = GameManager.inventory[slotIndex]
			if(Input.is_action_just_pressed("Interact") and itemSelected in GameManager.instants):
				if(itemSelected=="IceCream"):
					GameManager.food+=12
					GameManager.inventory.remove_at(slotIndex)
				elif(itemSelected=="Protein"):
					GameManager.food+=8
					GameManager.inventory.remove_at(slotIndex)
				elif(itemSelected=="H Mac"):
					GameManager.food+=20
					GameManager.water+=10
					GameManager.inventory.remove_at(slotIndex)
				elif(itemSelected=="H Cup"):
					GameManager.water+=20
					GameManager.inventory[slotIndex]="Cup"
				elif(itemSelected=="Carrots"):
					GameManager.water+=7.5
					GameManager.food+=15
					GameManager.carrots-=1
					if(GameManager.carrots<=0):
						GameManager.inventory.remove_at(slotIndex)
				else:
					print(itemSelected)
				GameManager.selectedSlot=-1
				$Outline.visible=false
		else:
			$Outline.visible=false
	else:
		visible=false


func _on_button_pressed() -> void:
	GameManager.selectedSlot=slotIndex
