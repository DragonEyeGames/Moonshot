extends Node2D

var powerEmission:=0
var dirt:=0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	powerEmission=abs(GameManager.sunPower)*3
	powerEmission-=dirt
	GameManager.basePower+=powerEmission*delta
	print(GameManager.basePower)
	print(powerEmission)
