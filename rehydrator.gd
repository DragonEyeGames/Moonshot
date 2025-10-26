extends Node2D

var colliding
var interactingList=["Mac", "Cup"]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact") and len(GameManager.inventory)>0 and interactingList.has(GameManager.inventory[GameManager.selectedSlot]) and not GameManager.selectedSlot==-1):
		GameManager.inventory[GameManager.selectedSlot]="H " + GameManager.inventory[GameManager.selectedSlot]
		GameManager.selectedSlot=-1


func _on_area_2d_body_entered(body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(body: Node2D) -> void:
	colliding=false
