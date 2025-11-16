extends Node2D

var zoomed=false

func _process(_delta: float) -> void:
	$Noise.texture.noise.seed+=1

func zoom():
	GameManager.zoomCamera($ZoomPoint, 3.8)
	zoomed=true
	GameManager.playerMove=false
	GameManager.flashlightOn=false
