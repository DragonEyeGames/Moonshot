extends Node2D

var state=""
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	$State.play("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	$State.play("exit")
	if(not state=="sealed"):
		GameManager.playerState="outside"


func _on_airlock_body_entered(body: Node2D) -> void:
	if(not state=="sealed"):
		state="sealed"
		GameManager.playerState="inside"
		$State.play("seal")


func _on_airlock_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
