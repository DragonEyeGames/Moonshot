extends ColorRect

var collision=false

var fading=false

var mouseEntered=false

var mouseTimeIn=0
var mouseTimeOut=0

var open=false

#func _ready():
	#newThings()
	
func _process(delta: float) -> void:
	if(not mouseEntered and open):
		mouseTimeOut+=delta
	if(mouseTimeOut>1):
		$open.play("close")
		mouseTimeOut=0
		open=false
		GameManager.player.bagOpen=false
	if(mouseEntered):
		mouseTimeIn+=delta
	if(mouseTimeIn>=1 and not open):
		openBag()
	elif(mouseEntered and Input.is_action_just_pressed("Click") and GameManager.player.handHeldItem=="" and not open):
		openBag()
	elif(Input.is_action_just_released("Click") and collision and GameManager.player.currentlyHeld!=null):
		if(GameManager.player.bagOpen==false):
			if(GameManager.player.pickedUpType=="plant"):
				GameManager.carrots+=1
			else:
				GameManager.add(GameManager.player.pickedUpType, 1)
				var holder=$BagItems.duplicate()
				$"Bag O' Holding".add_child(holder)
				holder.visible=true
				$"Bag O' Holding".get_child(-1).get_node(GameManager.player.pickedUpType).visible=true
				await get_tree().create_timer(.1).timeout
				loadInventory()
			GameManager.player.currentlyHeld.queue_free()
			GameManager.player.handHeldItem=""
	elif(Input.is_action_just_pressed("Interact") and not fading and visible):
		fading=true
		if(GameManager.interactedItem!=null):
			await get_tree().create_timer(1).timeout
			GameManager.interactedItem.unzoom()
		fading=false
		GameManager.playerTool=""

func _on_area_2d_area_entered(_area: Area2D) -> void:
	if(visible):
		collision=true


func _on_area_2d_area_exited(_area: Area2D) -> void:
	if(visible):
		collision=false


func _on_bag_mouse_entered() -> void:
	mouseTimeIn=0
	mouseTimeOut=0
	mouseEntered=true


func _on_bag_mouse_exited() -> void:
	mouseTimeOut=0
	mouseTimeIn=0
	mouseEntered=false
	
func openBag():
	$open.play("open")
	open=true
	GameManager.player.bagOpen=true

func newThings():
	var index=0
	#for item in GameManager.inventory:
	#	for child in $"Bag O' Holding".get_child(index).get_children():
	#		child.visible=false
	#	$"Bag O' Holding".get_child(index).get_node(item).visible=true
	#	index+=1
		
func loadInventory():
	GameManager.inventory.clear()
	for child in $"Bag O' Holding".get_children():
		print("LWOERLWE")
		if(child.visible):
			GameManager.add(child.item, 1)
	var items=0
	for item in GameManager.inventory:
		print("LOWKE")
		for i in range(item["count"]):
			$"Bag O' Holding".get_child(items).get_node(item["name"]).visible=true
			items+=1
	
func newItem(type, newLocation, newRotation, newScale):
	var holder=$BagItems.duplicate()
	$"Bag O' Holding".add_child(holder)
	print(type)
	holder.get_node(type).visible=true
	print(holder)
	holder.global_position=newLocation
	holder.global_rotation=newRotation
	holder.scale=newScale
	await get_tree().create_timer(.1).timeout
	print(holder.scale)
