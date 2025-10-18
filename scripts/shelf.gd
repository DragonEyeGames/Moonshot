extends Node2D

var colliding=false

@export var items=["", "", "", "", "", "", "", ""]
var positions=[Vector2(-22, -51), Vector2(24, -51), Vector2(-22, -40), Vector2(24, -40), Vector2(-22, 32), Vector2(24, 32), Vector2(-22, 112), Vector2(24, 112)]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for index in len(items):
		if(not items[index]==""):
			var selectedItem=$Possibilities.get_node(items[index]).duplicate()
			selectedItem.visible=true
			selectedItem.position=positions[index]
			$Shelf.add_child(selectedItem)
			selectedItem.scale=Vector2(.5, .5)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(colliding and Input.is_action_just_pressed("Interact") and len($Shelf.get_children())>0 and len(GameManager.inventory)<=4):
		var item = str($Shelf.get_child(0).get_child(0).name)
		GameManager.inventory.append(item)
		$Shelf.get_child(0).queue_free()


func _on_shelf_area_body_entered(_body: Node2D) -> void:
	colliding=true


func _on_shelf_area_body_exited(_body: Node2D) -> void:
	colliding=false
