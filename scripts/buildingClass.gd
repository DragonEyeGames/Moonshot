extends Node2D

var flickering=false

func _ready() -> void:
	GameManager.tapeHolder = $TapeHolder

func _process(_delta: float) -> void:
	if(not flickering):
		for light in $lights.get_children():
			light.energy=2.0-GameManager.sunPower
		if(randi_range(0, 1000)==67):
			flickering=true
			for light in $lights.get_children():
				light.energy=1.0
			await get_tree().create_timer(.1).timeout
			flickering=false
