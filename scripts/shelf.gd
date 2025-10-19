extends Node2D

var colliding=false
var zoomed=false
var canZoom=true

@export var items=["", "", "", "", "", "", "", ""]
var positions=[Vector2(-22, -51), Vector2(24, -51), Vector2(-22, -40), Vector2(24, -40), Vector2(-22, 32), Vector2(24, 32), Vector2(-22, 112), Vector2(24, 112)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for index in len(items):
		if(not items[index]==""):
			var selectedItem=$Possibilities.get_node(items[index]).duplicate()
			selectedItem.visible=true
			get_node(str(index+1)).add_child(selectedItem)
			selectedItem.global_position=get_node(str(index+1)).global_position
			#selectedItem.scale=Vector2(.5, .5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#prints(zoomed, len(GameManager.inventory)>4)
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom ):
			GameManager.interactedItem=null
			zoom()
		elif(zoomed and canZoom):
			unzoom()
		elif(canZoom and not zoomed):
			GameManager.hud.maxOut()
	#if(zoomed and len(GameManager.inventory)>4):
		#unzoom()
		#GameManager.hud.maxOut()
			


func _on_shelf_area_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_shelf_area_body_exited(_body: Node2D) -> void:
	colliding=false
	
func zoom():
	GameManager.zoomCamera($ZoomPoint, 3.8)
	zoomed=true
	canZoom=false
	GameManager.playerMove=false
	GameManager.flashlightOn=false
	GameManager.playerAnimator.play("fadeToArm")
	GameManager.player.handHeldItem=""
	GameManager.playerTool="bag"
	GameManager.collisionTool=self
	GameManager.player.get_node("CanvasLayer").get_node("PlantBag").newThings()
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerMove=true
	GameManager.playerTool=""
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	canZoom=true


func _on_killzone_body_entered(body: Node2D) -> void:
	if(GameManager.player.pickable==body):
		GameManager.player.handHeldItem=""
		GameManager.player.pickable=null
	body.set_deferred("freeze", true)
	await get_tree().create_timer(.1).timeout
	body.rotation=0
	body.linear_velocity=Vector2.ZERO
	body.global_position=body.get_parent().global_position
	await get_tree().create_timer(.1).timeout
	body.set_deferred("freeze", false)
