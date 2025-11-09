extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(len(GameManager.inventory)>=get_parent().get_parent().slotIndex+1 and GameManager.inventory[get_parent().get_parent().slotIndex]["name"]=="Jug"):
		$Jug2/Jug3.position=Vector2(-13.0, 390.0).lerp(Vector2(-13.0, -160.0), float(GameManager.inventory[get_parent().get_parent().slotIndex]["count"])/100.0)
