extends Node2D

var playerEntered:=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("Click")):
		openUp()
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		$Text.visible=!$Text.visible
		GameManager.playerMove=!$Text.visible

func openUp():
	$Door.play("open")

func _on_area_2d_body_entered(_body: Node2D) -> void:
	playerEntered=true


func _on_area_2d_body_exited(_body: Node2D) -> void:
	playerEntered=false
