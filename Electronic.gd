extends Node
class_name Electronic
@export var maxPower := .5
var power = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	power=maxPower


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	powerSap(delta)

func powerSap(_delta):
	GameManager.basePower-=power*_delta
	if(GameManager.basePower<0):
		if(power<abs(GameManager.basePower)):
			power=0
		else:
			power=abs(GameManager.basePower)
		GameManager.basePower=0
	power*=_delta
