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
	if(colliding and Input.is_action_just_pressed("Interact")):
		if(not zoomed and canZoom):
			GameManager.interactedItem=null
			zoom()
		elif(zoom and canZoom):
			unzoom()
			


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
	await get_tree().create_timer(1.1).timeout
	canZoom=true

func unzoom():
	GameManager.unzoomCamera()
	zoomed=false
	canZoom=false
	GameManager.playerMove=true
	GameManager.playerAnimator.play("revealToArm")
	await get_tree().create_timer(1.1).timeout
	canZoom=true
