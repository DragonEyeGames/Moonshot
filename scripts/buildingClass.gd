extends Node2D

var flickering:=false
var consumption:=0.0

func _ready() -> void:
	GameManager.tapeHolder = $TapeHolder

func _process(delta: float) -> void:
	if(not flickering and GameManager.basePower>=delta/10):
		GameManager.basePower-=(delta/10)*GameManager.lightNerf
		consumption=(delta/10)*GameManager.lightNerf
		for light in $lights.get_children():
			light.energy=2.0-(GameManager.sunPower / GameManager.lightNerf)
		if(randi_range(0, 1000)==67):
			flickering=true
			for light in $lights.get_children():
				light.energy=0.0
			await get_tree().create_timer(.1).timeout
			flickering=false
	elif(GameManager.basePower<delta):
		consumption=0
		for light in $lights.get_children():
				light.energy=0.0
	GameManager.lightConsumption=consumption
	for light in $lights.get_children():
		if(light.energy < get_parent().get_node("DirectionalLight2D").energy):
			light.energy=get_parent().get_node("DirectionalLight2D").energy
