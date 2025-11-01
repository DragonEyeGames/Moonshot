extends Node2D

var colliding
var interactingList=["Mac", "Cup"]
var water=100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$WurterJug/Jug3.position=Vector2(15.0, 270.0).lerp(Vector2(15.0, -155.0), float(water)/100.0)
	#water=GameManager.water
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1 and len(GameManager.inventory)<=4 and $WurterJug.visible):
		GameManager.pickedUpJugWater=water
		GameManager.add("Jug", water)
		$WurterJug.visible=false
		$JugOutline.visible=false
	elif(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot!=-1 and GameManager.inventory[GameManager.selectedSlot]["name"]=="Jug" and $WurterJug.visible==false):
		water=GameManager.inventory[GameManager.selectedSlot]["count"]
		GameManager.inventory.remove_at(GameManager.selectedSlot)
		$WurterJug.visible=true
		$JugOutline.visible=true
		GameManager.pickedUpJugWater=0
		GameManager.selectedSlot=-1
	if(colliding and Input.is_action_just_pressed("Interact") and len(GameManager.inventory)>0 and interactingList.has(GameManager.inventory[GameManager.selectedSlot]["name"]) and not GameManager.selectedSlot==-1):
		if(GameManager.inventory[GameManager.selectedSlot]["name"]=='Cup'):
			if(water>=20):
				water-=20
				GameManager.subtract("Cup", 1)
				GameManager.add("H Cup", 1)
			else:
				return
		else:
			if(water>=10):
				water-=10
				GameManager.inventory[GameManager.selectedSlot]["name"]="H " + GameManager.inventory[GameManager.selectedSlot]["name"]
			else:
				return
		GameManager.selectedSlot=-1
	#GameManager.water=water


func _on_area_2d_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false
