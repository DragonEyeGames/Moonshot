extends Node2D

var state=""
var flickering=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(not flickering):
		$PointLight2D.energy=(1.0-GameManager.sunPower)
	if(randi_range(1, 500)==67):
		$PointLight2D.energy=0
		flickering=true
		await get_tree().create_timer(.1).timeout
		flickering=false
		$PointLight2D.energy=(1.0-GameManager.sunPower)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if(not state=="sealed"):
		$DoorController.play("open")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if(not state=="sealed"):
		GameManager.playerState="outside"
		$DoorController.play("close")


func _on_airlock_body_entered(body: Node2D) -> void:
	if(state==""):
		state="sealing"
		GameManager.playerState="inside"
		$DoorController.play("seal")
		await get_tree().create_timer(3).timeout
		state="sealed"


func _on_airlock_body_exited(body: Node2D) -> void:
	pass # Replace with function body.


func _on_outer_body_entered(body: Node2D) -> void:
	if(state=="sealed"):
		state="opening"
		$DoorController.play("exit")
		GameManager.playerState="outside"
		await get_tree().create_timer(3).timeout
		state=""
