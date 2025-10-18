extends Node2D

var playerEntered=false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(playerEntered and Input.is_action_just_pressed("Interact")):
		var tween = create_tween()
		tween.tween_property(GameManager.player, "global_position", global_position, 1)
		GameManager.playerMove=false
		await get_tree().create_timer(2).timeout
		$CanvasLayer/SleepFade.play("sleep")
		await get_tree().create_timer(7).timeout
		var previousTime=GameManager.currentTime
		GameManager.currentTime=6
		$CanvasLayer/SleepFade.play("wakeup")
		GameManager.food-=12
		GameManager.water-=20
		GameManager.health+=20
		if(previousTime>6):
			GameManager.day+=1
		await get_tree().create_timer(5).timeout
		GameManager.playerMove=true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	playerEntered=true

func _on_area_2d_body_exited(_body: Node2D) -> void:
	playerEntered=false
