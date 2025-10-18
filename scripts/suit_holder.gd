extends Node2D

var colliding=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact") and GameManager.selectedSlot==-1):
		$Sprite2D.visible=!$Sprite2D.visible
		GameManager.helmet.visible=!GameManager.helmet.visible
		if(GameManager.helmet.visible==false):
			GameManager.flashlightOn=false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	colliding=false
