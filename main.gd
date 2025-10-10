extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.helmet=$player/Helmet
	GameManager.player=$player


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(GameManager.playerState)
	GameManager.currentTime+=delta/60
	if(GameManager.currentTime>24):
		GameManager.currentTime=0
		GameManager.day+=1
	#$DirectionalLight2D.energy= 0.05 + (abs(GameManager.currentTime) - 0) * (1 - 0) / (12-0.05)
	GameManager.sunPower=$DirectionalLight2D.energy
