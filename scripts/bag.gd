extends Control

var collision=false

var fading=false

var mouseEntered=false

var mouseTimeIn=0
var mouseTimeOut=0

var open=false

#func _ready():
	#newThings()
	
func _process(delta: float) -> void:
	print(GameManager.inventory)
	if(not mouseEntered and open):
		mouseTimeOut+=delta
	if(mouseTimeOut>1):
		mouseTimeOut=0
		open=false
		GameManager.player.bagOpen=false
		$open.play("close")
		await get_tree().create_timer(1).timeout
		loadInventory()
	if(mouseEntered):
		mouseTimeIn+=delta
	if(mouseTimeIn>=1 and not open):
		openBag()
	elif(mouseEntered and Input.is_action_just_pressed("Click") and GameManager.player.handHeldItem=="" and not open):
		openBag()
	elif(Input.is_action_just_released("Click") and collision and GameManager.player.pickable!=null and not GameManager.player.handHeldItem==""):
		print("ISSUES")
		if(GameManager.player.bagOpen==false):
			if(GameManager.player.handHeldItem=="plant"):
				GameManager.carrots+=1
			else:
				await GameManager.add(GameManager.player.handHeldItem, 1)
			if(GameManager.player.pickable):
				GameManager.player.pickable.queue_free()
			GameManager.player.handHeldItem=""
			GameManager.player.pickedUp=false
			GameManager.player.canPickUp=true
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
	loadInventory()
	$open.play("open")
	open=true
	GameManager.player.bagOpen=true

func newThings():
	var _index=0
	#for item in GameManager.inventory:
	#	for child in $"Bag O' Holding".get_child(index).get_children():
	#		child.visible=false
	#	$"Bag O' Holding".get_child(index).get_node(item).visible=true
	#	index+=1
		
func loadInventory():
	print("LOADING")
	#GameManager.inventory.clear()
	#for child in $"Bag O' Holding".get_children():
	#	if(child.visible):
	#		GameManager.add(child.item, 1)
	for child in $"Bag O' Holding".get_children():
		child.queue_free()
	for item in GameManager.inventory:
		if(not item["name"] in GameManager.nonstackingList):
			for i in range(item["count"]):
				print(item["name"])
				var holder=$BagItems.duplicate()
				$"Bag O' Holding".add_child(holder)
				holder.global_position=$"Points of Movement".get_child(randi_range(0, len($"Points of Movement".get_children())-1)).global_position
				holder.visible=true
				holder.get_node(item["name"]).visible=true
		else:
			var holder=$BagItems.duplicate()
			$"Bag O' Holding".add_child(holder)
			holder.visible=true
			holder.global_position=$"Points of Movement".get_child(randi_range(0, len($"Points of Movement".get_children())-1)).global_position
			holder.get_node(item["name"]).visible=true
	
func newItem(type, newLocation, newRotation):
	var holder=$BagItems.duplicate()
	$"Bag O' Holding".add_child(holder)
	holder.get_node(type).visible=true
	holder.global_position=newLocation
	#holder.scale = Vector2.ONE
	holder.rotation=newRotation
