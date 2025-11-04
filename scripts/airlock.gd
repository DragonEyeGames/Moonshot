extends Node2D

var state=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if(not state=="sealed"):
		$DoorController.play("open")


func _on_area_2d_body_exited(_body: Node2D) -> void:
	if(not state=="sealed"):
		GameManager.playerState=GameManager.possibleStates.OUTSIDE
		$DoorController.play("close")


func _on_airlock_body_entered(_body: Node2D) -> void:
	if(state==""):
		state="sealing"
		GameManager.playerState=GameManager.possibleStates.INSIDE
		$DoorController.play("seal")
		await get_tree().create_timer(3).timeout
		state="sealed"


func _on_airlock_body_exited(_body: Node2D) -> void:
	pass # Replace with function body.


func _on_outer_body_entered(_body: Node2D) -> void:
	if(state=="sealed"):
		state="opening"
		$DoorController.play("exit")
		GameManager.playerState=GameManager.possibleStates.OUTSIDE
		await get_tree().create_timer(3).timeout
		state=""
