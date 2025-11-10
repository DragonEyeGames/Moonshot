extends Node2D

var displayedPower:=0.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateEnergy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$Panel/ReservedAmount.text=str(int(round(GameManager.basePower*10)/10)) + "KWH"
	$"Panel/Input Amount".text=str((round(GameManager.currentEmission*10)/10)) + "KWH"
	$"Panel/Used Amount".text=str((round((displayedPower)*10)/10)) + "KWH"
	
func updateEnergy():
	print("UPDATOR")
	var previousPower=GameManager.basePower
	await get_tree().create_timer(1).timeout
	displayedPower=GameManager.basePower-previousPower
	updateEnergy()
