extends CanvasLayer

var playerDead=false
var sprintRegen=2
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(sprintRegen<=0):
		$Energy.value+=delta*10
	if(GameManager.playerState=="outside"):
		$Oxygen.visible=true
		$Oxygen.value-=delta/2
		if($Oxygen.value<=0 and playerDead==false):
			GameManager.player.queue_free()
			GameManager.player.get_node("Camera2D").reparent(GameManager.player.get_parent())
			playerDead=true
			await get_tree().create_timer(1).timeout
			get_tree().change_scene_to_file("res://oxygenSuffocation.tscn")
	else:
		$Oxygen.visible=false
	if(Input.is_action_pressed("Sprint") and $Energy.value>0):
		GameManager.playerSprinting=true
		$Energy.value-=delta*40
		sprintRegen=2
	else:
		sprintRegen-=delta
		GameManager.playerSprinting=false
