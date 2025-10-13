extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.helmet=$player/Helmet
	GameManager.player=$player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	GameManager.currentTime+=delta/60
	if(GameManager.currentTime>24):
		GameManager.currentTime=0
		GameManager.day+=1
	$DirectionalLight2D.energy = 0.05 + (1 - abs(GameManager.currentTime - 12) / 12) * (1 - 0.05)
	GameManager.sunPower=$DirectionalLight2D.energy
	if(Input.is_action_just_pressed("Escape")):
		get_tree().quit()
