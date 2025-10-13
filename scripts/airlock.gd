extends Node2D

var state=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(not state=="sealed"):
		$State.play("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(not state=="sealed"):
		GameManager.playerState="outside"
		$State.play("shut")


func _on_airlock_body_entered(body: Node2D) -> void:
	if(state==""):
		state="sealing"
		GameManager.playerState="inside"
		$State.play("seal")
		await get_tree().create_timer(3).timeout
		state="sealed"


func _on_airlock_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_outer_body_entered(body: Node2D) -> void:
	if(state=="sealed"):
		state="opening"
		$State.play("exit")
		GameManager.playerState="outside"
		await get_tree().create_timer(3).timeout
		state=""
